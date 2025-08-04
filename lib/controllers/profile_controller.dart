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
  bool isEditing = false;
  List<MyCoursesList> mycourses = [];
  bool emptyCourses = false;
  
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
    if(profile != null ) getProfile("Controller init");
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

  void editProfile(bool value) {
    isEnabled = value;
    update();
  }

  void cancelEdit(bool value) {
    isEnabled = value;
    update();
  }

  Future<void> getProfile(String caller) async {
    profile = await _apiService.getProfile(caller);
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
    update(["profile"]);
  }

  Future<void> updateProfile() async {
      try {
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
      isEditing = true;
      update(["updating"]);
      await _apiService.updateProfile(updateData).then((value) async {
        await getProfile("Update profile API");
      },);
    } catch (e) {
      debugPrint("Something wrong in edit API. ${e.toString()}", wrapWidth: 1064);
    } finally {
      isEditing = false;
      update(["updating"]);
    }
  }

  Future<void> downloadFile(String url, String fileName) => _apiService.downloadFile(url, fileName);
  
  Future<List<MyCoursesList>> getMyCourses() async {
    mycourses = await _apiService.getMyCourses();
    if (mycourses.isEmpty) {
      emptyCourses = true;
      update();
      return [];
    } else {
      emptyCourses = false;
      update();
      return mycourses;
    }
  }
}