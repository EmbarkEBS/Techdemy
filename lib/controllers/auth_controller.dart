import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/service/api_service.dart';
import 'package:tech/service/notification_service.dart';

class AuthController extends GetxController {
  final NotificationService notificationService = NotificationService();
  final ApiService _apiService = ApiService();
  // Login properties
  Map<String, String> loginMessage = {};
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController loginController = TextEditingController();
  bool isLoggingIn = false;
  bool isRegistering = false;
  bool isVerifying = false;
  bool isResending = false;
  // Register properties
  String gender = 'Gender';
  List<String> genders = ['Gender','Male','Female',];
  String usercategory = 'Select Type';
  List<String> userCategories = ['Select Type', 'Internship', 'Training',];
  String studentyear = 'Select Year';
  List<String> years = ['Select Year', '1', '2', '3', '4', '5',];
  String experiencelevel = 'Select Experience Level';
  List<String> experiencelevels = ['Select Experience Level', 'Fresher(0-2 Years)', '2+ Years', '5+ Years', '10+ Years'];

  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController registerNamecontroller = TextEditingController();
  final TextEditingController registerEmailcontroller = TextEditingController();
  final TextEditingController registerMobilecontroller = TextEditingController();
  final TextEditingController registerAddresscontroller = TextEditingController();
  final TextEditingController registerCollegecontroller = TextEditingController();
  final TextEditingController registerDepartmentcontroller = TextEditingController();
  Map<String, String> registerMessage = {};
  
  void selectGender(String value) {
    gender = value;
    update();
  }

  void selectCategory(String value) {
    usercategory = value;
    update();
  }

  void selectStudentYear(String value) {
    studentyear = value;
    update();
  }

  void selectExperience(String value) {
    experiencelevel = value;
    update();
  }


  // APi calls

  // Login
  Future<void> login() async {
    try {
      isLoggingIn = true;
      update();
      loginMessage = await _apiService.login(loginController.text);
    } catch (e) {
      log("Loggin issue", error: e.toString(), stackTrace: StackTrace.current);
    } finally {
      isLoggingIn = false;
      update();
    }
  }

  // Register
  Future<void> register() async {
    try {
      final Map<String, String> registerData = {
      "name": registerNamecontroller.text,
      "email": registerEmailcontroller.text,
      "phone_no": registerMobilecontroller.text,
      "gender": gender,
      "address": registerAddresscontroller.text,
      "user_category": usercategory,
      "college_name": registerCollegecontroller.text,
      "department": registerDepartmentcontroller.text,
      "year": studentyear,
      "exp_level": experiencelevel
    };
    isRegistering = true;
    update(["registering"]);
    registerMessage = await _apiService.register(registerData);
    update(["registering"]);
    } catch (e) {
      log("Registeration issue", error: e.toString(), stackTrace: StackTrace.current);
    } finally {
      isRegistering = false;
      update(["registering"]);
    }
  }
  
  Future<void> checkOtp(String otp, String mobile) async {
    isVerifying = true;
    update(["verifyOtp"]);
    await _apiService.checkOtp(otp, mobile);
    isVerifying = false;
    update(["verifyOtp"]);
  }

  // Resend OTP
  Future<void> resendOtp(String mobileNo) async {
    isResending = true;
    update(["resend"]);
    await _apiService.sendOTP(mobileNo);
    isResending = false;
    update(["resend"]);
  }
  
  void logout() => _apiService.logout();

  @override
  void dispose() {
    super.dispose();
    loginController.dispose();
    registerNamecontroller.dispose();
    registerEmailcontroller.dispose();
    registerMobilecontroller.dispose();
    registerAddresscontroller.dispose();
    registerCollegecontroller.dispose();
    registerDepartmentcontroller.dispose();
    gender = 'Gender';
    usercategory = 'Select Type';
    experiencelevel = 'Select Experience Level';
    studentyear = 'Select Year';
  }
}