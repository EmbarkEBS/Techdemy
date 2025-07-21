import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tech/Helpers/encrypter.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:http/http.dart' as http;
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/Models/profile_model.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/routes/routes.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final _storage = const FlutterSecureStorage();
  static const platform = MethodChannel('com.example.device_info');

  Future<String?> getDeviceId() async {
    try {
      final String? deviceId = await platform.invokeMethod('getDeviceId');
      return deviceId;
    } on PlatformException catch (e) {
      debugPrint("Failed to get device ID: '${e.message}'.");
      return null;
    }
  }

  /// Login -> Completed
  Future<Map<String, String>> login(String mobile) async {
    var url = 'https://techdemy.in/connect/api/userlogin';
    final Map<String, String> data = {
      "login_data": mobile
    };
    debugPrint("Decrypted data :${ encryption(json.encode(data))}");
    try {
      final response = await http.post(Uri.parse(url),
        body: {
          "data": encryption(json.encode(data))
        },
       ).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("login response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        Future.wait([
          _storage.write(key: "userId", value: result["user_id"].toString()),
          _storage.write(key: "mobileNo", value: mobile)
        ]);
        _storage.write(key: "${await getDeviceId()}_${await _storage.read(key: "userId")}", value: true.toString());
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        await sendOTP(mobile);
        Get.offNamed(AppRoutes.verification);
        return {"message": result["message"], "status": "success"};
      } else {
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        return {"message": result["message"], "status": "error"};
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: _.toString(), duration: const Duration(seconds: 1)));
      return {"message": _.message.toString(), "status": "error"};
    } on Exception catch (e) {
      log("Login error", error: e.toString(), stackTrace: StackTrace.current);
      return {"message": e.toString(), "status": "error"};
    }
  }

  Future<bool> checkLoggedIn() async {
    String value = await _storage.read(key: "${await getDeviceId()}_${await _storage.read(key: "userId")}") ?? "";
    log("Logged in user : ${await getDeviceId()}_${await _storage.read(key: "userId")}");
    if(value.isNotEmpty) {
      bool check = bool.tryParse(value) ?? false;
      log("Value of logged in user $check");
      return check;
    }
    return false;
  }
  
  /// Send OTP using instant alerts
  Future<void> sendOTP(String mobile) async {
    int otp = await generateOTP();
    String endpoint =  "https://sms.embarkinteractive.com/api/smsapi",
    key = "4263dd9a2485fe38217a8f4da1c546e5",
    sender = "INSTNE", templateid = "1407175160893343027",
    sms = Uri.encodeComponent("<#> $otp is your Techdemy OTP.\n NDeYICHXQsQ");
    try{
      String url = "$endpoint?key=$key&route=2&sender=$sender&number=$mobile&templateid=$templateid&sms=$sms";
      final response = await http.get(Uri.parse(url));
      log("OTP send response log: ${response.body}");
      if (response.statusCode == 200) {
        // await SmsAutoFill().listenForCode();
        await _storage.write(key: "otp", value: otp.toString());
      } else {
        await _storage.write(key: "otp", value: "");
      }
    } catch(e) {
      log("Error sending OTP:", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // Verify the OTP in local
  Future<void> checkOtp(String otp) async {
    String correct = await _storage.read(key: "otp") ?? "";
    if(correct.isNotEmpty && correct == otp) {
      _storage.write(key: "${await getDeviceId()}_${_storage.read(key: "userId")}", value: "true");
      Get.offNamed(AppRoutes.homepage);
    }
  }

  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    return otp;
  }

  /// Register
  Future<Map<String, String>> register(Map<String, dynamic> registerData) async {
    var url = 'https://techdemy.in/connect/api/userregister';
    try {
      final response = await http.post(Uri.parse(url),
        body: {
          "data" : encryption(json.encode(registerData))
        },
        ).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Registration response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        Future.wait([
          _storage.write(key: "userId", value: result["user_id"]),
          _storage.write(key: "mobileNo", value: result["phone_no"]),
          sendOTP(registerData["phone_no"])
        ]);
        Get.offNamed(AppRoutes.verification);
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        return {"message": result["message"], "status": "success"};
      } else if (result["status"] == "email_exist") {
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        return {"message": result["message"], "status": "error"};
      }  else {
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        return {"message" : "${response.statusCode} :Please Check your Internet Connection And data", "status" : "error"};
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(message: "Please Check your Internet Connection And data", duration: Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
      return {"message": "Please Check your Internet Connection And data", "status": "error"};
    } on Exception catch (e) {
      log("Registration error", error: e.toString(), stackTrace: StackTrace.current);
      return {"message": e.toString(), "status": "error"};
    }
  }

  // Otp verfication
  Future<void> otpVerify(String otp) async {
    var userId = await _storage.containsKey(key: "userId") ? _storage.read(key: "userId") : 0;
    var url = 'https://techdemy.in/connect/api/verifyotp';
    var mobileNo = await _storage.read(key: "mobileNo");
    final Map<String, String> data = {
      "login_data": mobileNo.toString(),
      "otp": otp,
      "user_id": userId.toString()
    };
    try {
      final response = await http.post(Uri.parse(url),
        body: json.encode({"data": encryption(json.encode(data))}),
        encoding: Encoding.getByName('utf-8'),).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Verify otp response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1))).close().then((value) {
          Get.offNamed(AppRoutes.homepage);
        },);  
        // May use this if something went wrong if (result["status"] == "expired")
      } else {
          Get.showSnackbar(const GetSnackBar(snackPosition: SnackPosition.TOP, message:  "OTP Expired click resend OTP", duration: Duration(seconds: 1)));
      } 
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(snackPosition: SnackPosition.TOP, message: "Please Check your Internet Connection And data", duration: Duration(seconds: 1)));
    } on Exception catch (e) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: e.toString(), duration: const Duration(seconds: 1)));
      log("Verifuy otp exception", error: e.toString(), stackTrace: StackTrace.current);
    }
  
  }

  // Resend OTP
  Future<void> resendOtp() async {
    var mobileNo = await _storage.read(key: "mobileNo");
    try {
      var url = 'https://techdemy.in/connect/api/resendotp';
      final Map<String, String> data = {
        "login_data": mobileNo.toString()
      };
      final response = await http.post(Uri.parse(url),
        body: json.encode({"data": encryption(json.encode(data))}),
        encoding: Encoding.getByName('utf-8'),
        ).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), "");
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Resend otp response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
      } else {
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(snackPosition: SnackPosition.TOP, message: "Please Check your Internet Connection And data", duration: Duration(seconds: 1)));
    } on Exception catch (e) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: e.toString(), duration: const Duration(seconds: 1)));
      log("Resend otp exception", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // Get course list
  Future<List<CourseList>> getCoursesList() async {
    var url = 'https://techdemy.in/connect/api/courselist';
    var response = await http.get(Uri.parse(url),);
    String decrptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
    Map<String, dynamic> result= json.decode(decrptedData);
    if (response.statusCode == 200) {
      log('Course list response log: ${result['results']}');
      List<CourseList> courses = [];
      for (var courselist in result['results']) {
        courses.add(CourseList.fromJson(courselist));
      }
      return courses;
    } else {
      return [];
    }
  }

  // Get course detail
  Future<CourseDetail?> getCoursesDetail(String courseId) async {
    //List<CourseDetail> list=[];
    var url = 'https://techdemy.in/connect/api/coursedetail';
    // SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {"course_id": courseId};
    final encodedData = json.encode(data);
    final encryptedData = encryption(encodedData);
    var response = await http.post(
      Uri.parse(url),
      body: {"data" : encryptedData},
    );
    log("Course detail Response log: ${response.body}");
    if (response.statusCode == 200) {
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      //Map<String,dynamic> result=json.decode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
      Map<String, dynamic> result = json.decode(decryptedData);
      debugPrint("Course detail: $result");
      return CourseDetail.fromJson(result);
    }
    return null;
  }

  /// Enroll course
  Future<void> enrollCourse(String courseId) async {
    var url = 'https://techdemy.in/connect/api/userenrollment';
    final Map<String, String> data = {
      "user_id": await _storage.read(key: "userId") ?? "",
      "course_id": courseId,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "data": encryption(json.encode(data))
        }),
        ).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Enroll course response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        debugPrint("result$result");
        Get.showSnackbar(GetSnackBar(
          snackPosition: SnackPosition.TOP, 
          message: result["message"], 
          duration: const Duration(seconds: 1)
        ));
        // 
      } else {
        Get.showSnackbar(GetSnackBar(
          snackPosition: SnackPosition.TOP, 
          message: result["message"], 
          duration: const Duration(seconds: 1)
        ));
        Get.toNamed(AppRoutes.mycourses);
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: _.toString(), duration: const Duration(seconds: 1)));
    } on Exception catch (e) {
      log("Enroll courses exception", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // Get user Profile
  Future<ProfileModel?> getProfile(String caller) async {
    var url = 'https://techdemy.in/connect/api/userprofile';
    final Map<String, String> data = {
      "user_id": await _storage.read(key: "userId") ?? ""
    };
    String encodedData = json.encode(data);
    final encryptedData = encryption(encodedData);
    log("encryption data of profile $encryptedData");
    final response = await http.post(Uri.parse(url),
      body: {"data": encryptedData}).timeout(const Duration(seconds:20)
    ); 
    log("Profile: ${response.body.toString()}");
    String a = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    Map<String, dynamic> result = jsonDecode(a) as Map<String, dynamic>;
    log("Profile details log: $result", name: caller);
    if (response.statusCode == 200 && result["status"] == "success") {
      return ProfileModel.fromJson(result["results"]);
    } else {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
    }
    return null;
  }
  
  // update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    var url = 'https://techdemy.in/connect/api/updateprofile';
    try {
      Map<String, String> dat = {
        "data": encryption(json.encode(data))
      };
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(dat),
        ).timeout(const Duration(seconds:20)
      );
      String decrptedData = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(decrptedData) as Map<String, dynamic>;
      log("Update profile response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
         Future.wait([
          _storage.write(key: "userId", value: result["user_id"].toString()),
          _storage.write(key: "mobileNo", value: result["phone_no"])
        ]);
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
      } else {
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message:  result["message"], duration: const Duration(seconds: 1)));
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(message: "Please Check your Internet Connection And data", snackPosition: SnackPosition.TOP, duration: Duration(seconds: 1)));
    } on Exception catch (e) {
      log("Update profile exception log", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // My courses
  Future<List<MyCoursesList>> getMyCourses() async {
    var url = 'https://techdemy.in/connect/api/mycourse';
    final Map<String, String> data = {
      "user_id": await _storage.read(key: "userId") ?? ""
    };
    String encodedData = json.encode(data);
    String encryptedData = encryption(encodedData);
    var response = await http.post(
      Uri.parse(url),
      body: {"data": encryptedData},
    );
    String decrptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
    Map<String, dynamic> jsonData = json.decode(decrptedData);
    try {
      var jsonArray = jsonData['results'] as List<dynamic>;
      if (response.statusCode == 200) {
        log('My courses log:$jsonData');
        List<MyCoursesList> courses = jsonArray.map((e) => MyCoursesList.fromJson(e),).toList();
        return courses;
      } else {
        return [];
      }
    } on Exception catch (e) {
      log("My courses exception", error: e.toString(), stackTrace: StackTrace.current);
    }
    return [];
  }

  // Download files
  Future<void> downloadFile(String url, String fileName) async {
    try {
      Directory? downloadDirectory = await getExternalStorageDirectory();
      if (downloadDirectory == null) {
        throw 'there is no downloads direcotry found';
      }
      String filePath = '${downloadDirectory.path}/$fileName.docx';
      File file = File(filePath);

      if (await file.exists()) {
        Get.showSnackbar(GetSnackBar(
          message: "File already exists", 
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP, 
          mainButton:  SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
        ),);
        return;
      }
      http.Response response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      AlertDialog(
        title: Text('File downloaded and saved to: ${file.path}'),
        actions: [
          SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
        ],
      );
      Get.showSnackbar(
        GetSnackBar(
          message: 'File downloaded and saved to: ${file.path}',
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP, 
          mainButton: SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
        ),
      );
      log('File downloaded and saved to: ${file.path}');
    } catch (e) {
      log('Error downloading file exception: $e');
    }
  }

  // Quiz List
  Future<List<QuizQuestion>> quizList(int chapterId) async {
    Map<String, dynamic> userData = {
      'chapter_id': chapterId
    };
    final jsonData = json.encode(userData);
    final encryptedData = encryption(jsonData);
    String url = 'https://techdemy.in/connect/api/quizlist';
     var response = await http.post(
      Uri.parse(url),
      body: {
        "data": encryptedData
      },
    );
    String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    Map<String, dynamic> decodedResponse = json.decode(decryptedData);
    log("Quiz list response log: $decodedResponse");
    final result = decodedResponse["results"] as List<dynamic>;
    if (response.statusCode == 200) {
      List<QuizQuestion> questions = result.map((quiz) => QuizQuestion.fromJson(quiz),).toList();
      return questions;
    }
    return [];
  }

  // Submit Quiz
  
  Future<bool> submitQuestions(Map<int, int?> selectedAnswers) async {
    final formattedAnswers = selectedAnswers.entries.map((entry) => {
      'question_id': entry.key,
      'selected_option_index': entry.value,
    }).toList();

    const url = 'https://techdemy.in/connect/api/submitquiz';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"data": encryption(json.encode(formattedAnswers))}),
      );

      if (response.statusCode == 200) {
        String decryptedData = decryption(response.body);
        Map<String, dynamic> result = json.decode(
          decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
        );

        String message = result['message'] ?? 'Quiz Submitted Successfully';
        if('Quiz Submitted Successfully' == message) return true;
        // Show result popup at center
        return true;
      } else {
       return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  // Logout
  void logout() => Get.offAllNamed(AppRoutes.login);


  ApiService._internal();
  factory ApiService() => _instance;
}