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
import 'package:tech/Models/completed_chapters_model.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:http/http.dart' as http;
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/Models/profile_model.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/Screens/quiz_result_page.dart';
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
        await _storage.write(key: "userId", value: result["user_id"].toString());
        await _storage.write(key: "mobileNo", value: mobile);
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        await sendOTP(mobile);
        Get.offNamed(AppRoutes.verification, arguments: mobile);
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
    String mobile = await _storage.read(key: "mobileNo") ?? "";
    String userId = await _storage.read(key: "userId") ?? "";
    String value = await _storage.read(key: "${mobile}_$userId") ?? "";
    log("Logged in user : ${mobile}_$userId");
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
    String endpoint =  "http://sms.embarkinteractive.com/api/smsapi",
    key = "43d8000e89c7cf43bb5f35b048b71fe1",
    sender = "INSTNE", templateid = "1407175160893343027",
    sms = ("$otp is your Techdemy OTP. NDeYICHXQsQ");
    try{
      String url = "$endpoint?key=$key&route=2&sender=$sender&number=$mobile&templateid=$templateid&sms=$sms";
      final response = await http.get(Uri.parse(url));
      log("OTP send response log: ${response.body}", name: url);
      if (response.statusCode == 200) {
        // await SmsAutoFill().listenForCode();
        await _storage.write(key: "otp", value: otp.toString());
      } else {
        await _storage.write(key: "otp", value: "");
      }
    } on http.ClientException catch (_) {
      Get.showSnackbar(const GetSnackBar(message: "Can't send otp try again later", duration: Duration(seconds: 3), snackPosition: SnackPosition.TOP,),);
    } on Exception catch (e) {
      log("Error sending OTP:", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // Verify the OTP in local
  Future<void> checkOtp(String otp, String phone) async {
    String correct = await _storage.read(key: "otp") ?? "";
    String userId = await _storage.read(key: "userId") ?? "";
    String mobile = await _storage.read(key: "mobileNo") ?? phone;
    String verified = await _storage.read(key: "${mobile}_$userId") ?? "";
    if(correct.isNotEmpty && correct == otp) {
      if(verified != "true") {
        await verifyUser(mobile);
      }
    } else {
      Get.showSnackbar(const GetSnackBar(snackPosition: SnackPosition.TOP, message:  "Enter the correct OTP", duration: Duration(seconds: 1)));
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
        await _storage.write(key: "userId", value: result["user_id"].toString());
        await _storage.write(key: "mobileNo", value: result["phone_no"]);
        await sendOTP(registerData["phone_no"]);
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: const Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        Get.offNamed(AppRoutes.verification, arguments: result["phone_no"]);
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
  Future<void> verifyUser(String mobile) async {
    var userId = await _storage.containsKey(key: "userId") ? await _storage.read(key: "userId") : 0;
    var url = 'https://techdemy.in/connect/api/verifyuser';
    String deviceId = await getDeviceId() ?? "";
    String useId = await _storage.read(key: "userId") ?? '';
    final Map<String, String> data = {
      "device_id": deviceId,
      "user_id": userId.toString(),
      "mobile_no": mobile,
    };
    String encodedData = json.encode(data);
    String encryptedData = encryption(encodedData);
    try {                                                                  
      final response = await http.post(Uri.parse(url),
        body:{"data": encryptedData},
        encoding: Encoding.getByName('utf-8'),).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Verify user response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        await _storage.write(key: "mobileNo", value: mobile);
        await _storage.write(key: "${mobile}_$useId", value: true.toString());
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1))).close().then((value) {
          Get.offNamed(AppRoutes.bottom);
        },);
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
  Future<CourseDetail?> getCoursesDetail(String courseId, [String? enrollId]) async {
    //List<CourseDetail> list=[];
    var url = 'https://techdemy.in/connect/api/coursedetail';
    // SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {"course_id": courseId, "enroll_id": enrollId};
    final encodedData = json.encode(data);
    final encryptedData = encryption(encodedData);
    var response = await http.post(
      Uri.parse(url),
      body: {"data" : encryptedData},
    );
    log("Course detail response log: ${response.body}");
    if (response.statusCode == 200) {
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = json.decode(decryptedData);
      log("Course detail response log: $result");
      return CourseDetail.fromJson(result);
    }
    return null;
  }

  /// Enroll course
  Future<void> enrollCourse({
    required String courseId, 
    required String paymentType, 
    required String paymentStatus, 
    required String amountPaid, 
    required String balance
  }) async {
    var url = 'https://techdemy.in/connect/api/userenrollment';
    String userId =  await _storage.read(key: "userId") ?? "";
    final Map<String, String> data = {
      "user_id": userId,
      "course_id": courseId,
      "payment_type": paymentType,
      "amount_paid": amountPaid,
      "balance": balance,
      "payment_status": paymentStatus
    };
    String encodedData = json.encode(data);
    String encryptedData = encryption(encodedData);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {"data": encryptedData},
        ).timeout(const Duration(seconds: 20)
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(decryptedData) as Map<String, dynamic>;
      log("Enroll course response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
        debugPrint("result$result");
        await _storage.write(key: "${userId}_$courseId", value: true.toString());
        Get.showSnackbar(GetSnackBar(
          snackPosition: SnackPosition.TOP, 
          message: result["message"], 
          duration: const Duration(seconds: 1)
        ));
        // Get.toNamed(AppRoutes.mycourses);
      } else {
        Get.showSnackbar(GetSnackBar(
          snackPosition: SnackPosition.TOP, 
          message: result["message"], 
          duration: const Duration(seconds: 1)
        ));
        // Get.toNamed(AppRoutes.mycourses);
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: _.toString(), duration: const Duration(seconds: 1)));
    } on Exception catch (e) {
      log("Enroll courses exception", error: e.toString(), stackTrace: StackTrace.current);
    }
  }

  // Check enroll
  Future<bool> checkEnroll(String courseId) async {
    String userId =  await _storage.read(key: "userId") ?? "";
    String? status =  await _storage.read(key: "${userId}_$courseId");
    if(status != null && status.isNotEmpty) {
      return status == "true";
    }
    return false;
  }

  // Completed chapterlist for courses
  Future<List<CompletedChaptersModel>> completedChaptersList(String courseId) async {
    const url = 'https://techdemy.in/connect/api/completedchapterlist';
    String userId = await _storage.read(key: "userId") ?? "";
    final Map<String, String> data = {
      "user_id": userId,
      "course_id": courseId
    };
    String encodedData = json.encode(data);
    String encryptedData = encryption(encodedData);
    final response = await http.post(
      Uri.parse(url),
      body: {"data": encryptedData},
    );
    String decrptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
    Map<String, dynamic> jsonData = json.decode(decrptedData);
    
    log('Completed chapters log : $jsonData');
    try {
      if (response.statusCode == 200 && jsonData["status"] == null) {
        final jsonArray = jsonData['results'] as List<dynamic>;
        List<CompletedChaptersModel> completedChapters = jsonArray.map((e) => CompletedChaptersModel.fromJson(e),).toList();
        return completedChapters;
      } else {
        return [];
      }
    } on Exception catch (e) {
      log("My courses exception", error: e.toString(), stackTrace: StackTrace.current);
    }
    return [];
  }

  // Get user Profile
  Future<ProfileModel?> getProfile(String caller) async {
    String userId = await _storage.read(key: "userId") ?? "";
    String profile = await _storage.read(key: "${userId}_profile") ?? "";
    if(caller != "Update profile API" && profile.isNotEmpty) {
      Map<String, dynamic> result = jsonDecode(profile);
      return ProfileModel.fromJson(result["results"]);
    } else {
      try {
        var url = 'https://techdemy.in/connect/api/userprofile';
        final Map<String, String> data = {
          "user_id": userId
        };
        String encodedData = json.encode(data);
        final encryptedData = encryption(encodedData);
        log("encryption data of profile $data");
        final response = await http.post(Uri.parse(url),
          body: {"data": encryptedData}).timeout(const Duration(seconds:20)
        );
        String decryptedResponse = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
        Map<String, dynamic> result = jsonDecode(decryptedResponse);
        log("Profile details log: $result", name: caller);
        await _storage.write(key: "${userId}_profile", value: decryptedResponse);
        if (response.statusCode == 200 && result["status"] == "success") {
          return ProfileModel.fromJson(result["results"]);
        } else {
          Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
          return null;
        }
      } on Exception catch (e) {
        log("Something went wrong : ", error: e.toString());
      }
      return null;
    }
  }
  
  // update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    var url = 'https://techdemy.in/connect/api/updateprofile';
    try {
      data["user_id"] = await _storage.read(key: "userId") ?? ""; 
      String encodedData = json.encode(data);
      String encryptedData = encryption(encodedData);
      final response = await http.post(
        Uri.parse(url),
        body: {"data": encryptedData},
        ).timeout(const Duration(seconds:20)
      );
      String decrptedData = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(decrptedData) as Map<String, dynamic>;
      log("Update profile response log $result");
      if (response.statusCode == 200 && result["status"] == "success") {
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
    String userId = await _storage.read(key: "userId") ?? "";
    final Map<String, String> data = {
      "user_id": userId
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
        Future.wait(courses.map((e) async => await _storage.write(key: "${userId}_${e.courseId}", value: true.toString()),));
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
          snackPosition: SnackPosition.BOTTOM, 
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
          snackPosition: SnackPosition.BOTTOM, 
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
  Future<void> submitQuestions(Map<String, dynamic> submitQuestionData) async {
    try {
      String userId = await _storage.read(key: "userId") ?? "";
      submitQuestionData["user_id"] = userId;
      const url = 'https://techdemy.in/connect/api/quizsubmit';
      String encodedData = json.encode(submitQuestionData);
      String encryptedData = encryption(encodedData);
      final response = await http.post(
        Uri.parse(url),
        body: {"data": encryptedData},
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = json.decode(decryptedData);
      if (response.statusCode == 200 && result["status"] == "success") {
        log("Quiz submitted $decryptedData");
        await _storage.write(key: "${userId}_${submitQuestionData["chapter_id"]}", value: "true");
        Get.off(() => QuizResultScreen(total: submitQuestionData["no_of_questions"], correct: submitQuestionData["correct_answers"]));
      } 
    } catch (e) {
      throw Exception(e);
    }
  }

  // check submitted quiz
  Future<bool> checkResult(String chapterId) async {
    String userId = await _storage.read(key: "userId") ?? "";
    String value =  await _storage.read(key: "${userId}_$chapterId") ?? "false";
    if(bool.tryParse(value) ?? false) return true;
    return false;
  }

  // Quiz result
  Future<void> quizResult(String chapterId) async {
    try {
      String userId = await _storage.read(key: "userId") ?? "";
      Map<String, dynamic> data = {
        "user_id": userId,
        "chapter_id": chapterId
      };
      const url = 'https://techdemy.in/connect/api/quizresult';
      String encodedData = json.encode(data);
      String encryptedData = encryption(encodedData);
      final response = await http.post(
        Uri.parse(url),
        body: {"data": encryptedData},
      );
      String decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = json.decode(decryptedData);
      if (response.statusCode == 200) {
        log("Quiz result $decryptedData");
        Get.off(() => QuizResultScreen(total: int.tryParse(result["results"]["total"]) ?? 0, correct: int.tryParse(result["results"]["result"]) ?? 0));
      } else {
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Login activity
  Future<void> logActivity() async {
    var url = 'https://techdemy.in/connect/api/logactivity';
    String userId = await _storage.read(key: "userId") ?? "";
    String deviceId = await getDeviceId() ?? "";
    final Map<String, String> data = {
      "user_id": userId,
      "device_id": deviceId
    };
    String encodedData = json.encode(data);
    final encryptedData = encryption(encodedData);
    log("Encryption of log in activity: $encryptedData");
    final response = await http.post(Uri.parse(url),
      body: {"data": encryptedData}).timeout(const Duration(seconds:20)
    );
    String a = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    Map<String, dynamic> result = jsonDecode(a) as Map<String, dynamic>;
    log("Response of login: $result", );
    if (response.statusCode == 200 && result["status"] == "success") {
      log("Logged in user $userId at $deviceId", time: DateTime.now());
    } else {
      log("Logged in not success $userId at $deviceId", time: DateTime.now());
    }
  }
  

  // Logout
  void logout() => Get.offAllNamed(AppRoutes.login);


  ApiService._internal();
  factory ApiService() => _instance;
}