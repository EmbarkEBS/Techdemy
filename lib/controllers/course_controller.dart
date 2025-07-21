import 'dart:math';
import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/service/api_service.dart';

class CourseController extends GetxController{
  final RxList<CourseList> courseList = <CourseList>[].obs;
  final ApiService _apiService = ApiService();
  CourseDetail? courseDetail;
  final random = Random();
  bool descTextShowFlag = true;
  Map<String, bool> isEnrolling = <String, bool>{};

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
    try {
      isEnrolling[courseId] = true;
      update(['enroll_$courseId']);
      await Future.delayed(const Duration(seconds: 2));
      await _apiService.enrollCourse(courseId);
    } catch (e) {
      dev.log("Enroll course issue", error: e.toString(), stackTrace: StackTrace.current);
    } finally {
      isEnrolling[courseId] = false;
      update(['enroll_$courseId']);
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    await _apiService.downloadFile(url, fileName);
  }

  Future<List<QuizQuestion>> quizList(int chapterId) async => await _apiService.quizList(chapterId);

  Future<void> logout() async => _apiService.logout();
}