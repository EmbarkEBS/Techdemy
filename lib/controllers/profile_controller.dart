import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/Models/profile_model.dart';
import 'package:tech/service/api_service.dart';

class ProfileController extends GetxController{
  final ApiService _apiService = ApiService();
  ProfileModel? profile; 
  final random = Random();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController mobilecontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  final TextEditingController collegecontroller = TextEditingController();
  final TextEditingController departmentcontroller = TextEditingController();

  
  String gender = 'Gender';
  var items1 = [
    'Gender',
    'Male',
    'Female',
  ];

  String usercategory = 'Select Type';
  var items2 = [
    'Select Type',
    'Internship',
    'Training',
  ];

  String studentyear = 'Select Year';
  var items3 = [
    'Select Year',
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  String experiencelevel = 'Select Experience Level';
  List<String> items4 = [
    'Select Experience Level',
    'Fresher(0-2 Years)',
    '2+ Years',
    '5+ Years',
    '10+ Years'
  ];


  bool isEnabled = false;
  

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

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

  Future<void> getProfile() async {
    profile = await _apiService.getProfile();
    namecontroller.text = profile!.name;
    gender = profile!.gender;
    addresscontroller.text = profile!.address;
    emailcontroller.text = profile!.email;
    mobilecontroller.text =profile!.mobile;
    usercategory = profile!.usercategory;
    collegecontroller.text = profile!.collegename;
    departmentcontroller.text = profile!.department;
    studentyear = profile!.studentyear;
    experiencelevel = profile!.experiencelevel;
    update();
  }

  Future<void> updateProfile() async {
    final updateData  = {
      "user_id": profile!.id,
      "name": namecontroller.text,
      "gender": gender,
      "address": addresscontroller.text,
      "email": emailcontroller.text,
      "phone_no": mobilecontroller.text,
      "user_category": usercategory,
      "college_name": collegecontroller.text,
      "department": departmentcontroller.text,
      "year": studentyear,
      "exp_level": experiencelevel
    };
    await _apiService.updateProfile(updateData);
  }

  Future<List<MyCoursesList>> getMyCourses() async => await _apiService.getMyCourses();
}