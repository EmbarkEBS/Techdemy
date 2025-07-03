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
import 'package:shared_preferences/shared_preferences.dart';
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
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setInt("user_id", result["user_id"]);
        sp.setString("login_data", mobile);
        _storage.write(key: "${getDeviceId()}_${sp.getInt("user_id")}", value: true.toString());
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
        Get.offNamed(AppRoutes.verification);
        return {"message": result["message"], "status": "success"};
      } else {
        Get.showSnackbar(GetSnackBar(message: result["message"], duration: Duration(seconds: 1), snackPosition: SnackPosition.TOP,),);
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    String value = await _storage.read(key: "${getDeviceId()}_${sp.getInt("user_id")}") ?? "";
    if(value.isNotEmpty) {
      bool check = bool.tryParse(value) ?? false;
      return check;
    }
    return false;
  }
  
  /// Send OTP using instant alerts
  Future<void> sendOTP(String mobile) async {
    try{
      int otp = await generateOTP();
      // TODO: Change them with techdemy API key, templateId, sender and sms
      String endpoint =  "https://sms.embarkinteractive.com/api/smsapi",
      key = "d6c8a9db43d8789803f77ab74c02ab9d", // TODO : add key here
      sender = "INSTNE", templateid = "1407175039545567178", 
      sms = "<#> $otp is your Techdemy OTP. NDeYICHXQsQ" ;
      String url = "$endpoint?key=$key&route=2&sender=$sender&number=$mobile&templateid=$templateid&sms=$sms";
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {

      } else {
        
      }
    } catch(e) {
      log("Error sending OTP:", error: e.toString(), stackTrace: StackTrace.current);
    }
  }


  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    // await storeOtp(otp.toString());
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
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setInt("user_id", result["user_id"]);
        sp.setString("login_data", registerData["phone_no"]);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed(AppRoutes.login);
        });
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    var userId = sp.containsKey("user_id") ? sp.getInt("user_id") : 0;
    var url = 'https://techdemy.in/connect/api/verifyotp';
    var loginData = sp.getString("login_data");
    // var email = sp.getString("email");
    final Map<String, String> data = {
      "login_data": loginData.toString(),
      "otp": otp,
      "user_id": userId!.toString()
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
      // else {
      //   Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message:  result["message"], duration: const Duration(seconds: 1)));
      //   String message = "Please Check your Internet Connection And data statusCode - 3 ${response.statusCode.toString()}";
      //   Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: message, duration: const Duration(seconds: 1)));
      // }
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(snackPosition: SnackPosition.TOP, message: "Please Check your Internet Connection And data", duration: Duration(seconds: 1)));
    } on Exception catch (e) {
      Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: e.toString(), duration: const Duration(seconds: 1)));
      log("Verifuy otp exception", error: e.toString(), stackTrace: StackTrace.current);
    }
  
  }

  // Resend OTP
  Future<void> resendOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var loginData = sp.getString("login_data");
    try {
      var url = 'https://techdemy.in/connect/api/resendotp';
      final Map<String, String> data = {
        "login_data": loginData.toString()
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
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({"data": encryption(json.encode(data))}),
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    final Map<String, String> data = {
      "user_id": sp.getInt("user_id").toString(),
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
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var url = 'https://techdemy.in/connect/api/userprofile';
      final Map<String, String> data = {
        "user_id": sp.getInt("user_id").toString()
      };
      Map<String, String> dat = {
        "data": encryption(json.encode(data))
      };
      final response = await http.post(Uri.parse(url),
        body: json.encode(dat),).timeout(const Duration(seconds:20)
      ); 
      String a = decryption(response.body.toString()).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
      Map<String, dynamic> result = jsonDecode(a) as Map<String, dynamic>;
      log("Profile details log: $result", name: caller);
      if (response.statusCode == 200 && result["status"] == "success") {
        return ProfileModel.fromJson(result["results"]);
      } else {
        Get.showSnackbar(GetSnackBar(snackPosition: SnackPosition.TOP, message: result["message"], duration: const Duration(seconds: 1)));
      }
      return null;
    } on TimeoutException catch (_) {
      Get.back();
    } on Exception catch (e) {
      log("My profile exception", error: e.toString(), stackTrace: StackTrace.current);
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
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setInt("user_id", int.parse(data["user_id"]));
        sp.setString("login_data", data["phone_no"]);
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    final Map<String, String> data = {
      "user_id": sp.getInt("user_id").toString()
    };
    Map<String, String> dat = {"data": encryption(json.encode(data))};
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(dat),
    );
    String decrptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), '');
    Map<String, dynamic> jsonData = json.decode(decrptedData);
    try {
      log('My courses log:$jsonData');
      var jsonArray = jsonData['results'];
      if (response.statusCode == 200) {
        List<MyCoursesList> courses = [];
        //List<TagData> tag=[];
        for (var courselist in jsonArray) {
          MyCoursesList cList = MyCoursesList(
            course_id: courselist['course_id'],
            name: courselist['name'],
            description: courselist['description'],
            price: courselist['price'],
            duration: courselist['duration'],
            image: courselist['image'],
            tag_data: courselist['tag_data'],
            enroll_id: courselist['enroll_id'],
            percentage: courselist['percentage'],
            course_status: courselist['course_status'],
            certificate_file: courselist['certificate_file']
          );
          var coursestatus = courselist['course_status'];
          if (coursestatus == "OnGoing") {
          }
          courses.add(cList);
        }
        return courses;
      } else {
        return [];
      }
    } on TimeoutException catch (_) {
      Get.showSnackbar(const GetSnackBar(message: "Please Check your Internet Connection And data", snackPosition: SnackPosition.TOP,  duration: Duration(seconds: 1)));
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
  Future<List<QuizQuestion>> quizList(String courseId, String chapterId) async {
    Map<String, dynamic> userData = {
      "course_id": courseId,
      'chapter_id': chapterId
    };
    // final jsonData = json.encode(userData);
    // String url = 'https://techdemy.in/connect/api/quizlist';
    // TODO: implement the API call and return original list
    return [];
  }

  // Logout
  void logout() => Get.offAllNamed(AppRoutes.login);


  ApiService._internal();
  factory ApiService() => _instance;
}