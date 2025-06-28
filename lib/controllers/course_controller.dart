import 'dart:math';

import 'package:get/get.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:tech/service/api_service.dart';

class CourseController extends GetxController{
  final RxList<CourseList> courseList = <CourseList>[].obs;
  final ApiService _apiService = ApiService();
  CourseDetail? courseDetail;
  final random = Random();
  bool descTextShowFlag = true;
  
  List<String> categories = ['All', 'PHP', 'JAVA', 'DBMS', 'MYSQL'];
  String selectedCategory = 'All';

  void selectDesc(bool value) {
    descTextShowFlag = value;
    update();
  }

  Future<List<CourseList>> getCoursesList() async {
   return await _apiService.getCoursesList();
  }

  Future<void> getCoursesDetail(String courseId) async {
    courseDetail  = await _apiService.getCoursesDetail(courseId);
    update();
  }

  Future<void> enrollCourse(String courseId) async {
    await _apiService.enrollCourse(courseId);
  }

  Future<void> downloadFile(String url, String fileName) async {
    await _apiService.downloadFile(url, fileName);
  }

  Future<void> getProfile() async => await _apiService.getProfile();

  Future<void> logout() async => _apiService.logout();
}