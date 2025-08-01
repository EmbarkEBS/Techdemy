import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/completed_chapters_model.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/controllers/profile_controller.dart';
import 'package:tech/service/api_service.dart';

class CourseController extends GetxController{
  final RxList<CourseList> courseList = <CourseList>[].obs;
  final ApiService _apiService = ApiService();
  CourseDetail? courseDetail;
  final random = Random();
  bool descTextShowFlag = true;
  Map<String, bool> isEnrolling = <String, bool>{};
  Map<int, bool> loadingQuiz = {};
  final ScrollController scrollController = ScrollController();
  List<CourseList> courses = [];
  List<CompletedChaptersModel> completedChapters = [];
  var quizSubmitted = <String, RxBool>{}.obs;

  List<String> categories = ['All', 'PHP', 'JAVA', 'DBMS', 'MYSQL'];
  String selectedCategory = 'All';
  

  void selectDesc(bool value) {
    descTextShowFlag = value;
    update();
  }

  Future<bool> checkEnroll(int courseId) async {
    bool status = await _apiService.checkEnroll(courseId.toString());
    return status;
  }

  // Get completed course list
  Future<void> getCompletedChapters(String courseId) async {
    completedChapters = await _apiService.completedChaptersList(courseId);
    update();
  }

  Future<List<CourseList>> getCoursesList() async {
   courses = await _apiService.getCoursesList();
   update();
   return courses;
  }

  Future<void> getCoursesDetail(String courseId) async {
    courseDetail  = await _apiService.getCoursesDetail(courseId);
    update();
  }

  // Enroll course
  Future<void> enrollCourse(String courseId) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _apiService.enrollCourse(courseId).then((value) {
        Get.find<ProfileController>().getMyCourses();
      },);
    } catch (e) {
      dev.log("Enroll course issue", error: e.toString(), stackTrace: StackTrace.current);
    } 
  }

  // load the button for enrolling course
  void loadEnroll(String courseId, bool value) async {
    isEnrolling[courseId] = value;
    update(["enrollBtn"]);
  }

  // Download certificate file
  Future<void> downloadFile(String url, String fileName) async {
    await _apiService.downloadFile(url, fileName);
  }

  Future<void> logActivity() async => await _apiService.logActivity();

  Future<List<QuizQuestion>> quizList(int chapterId) async {
    try {
      loadingQuiz[chapterId] = true;
      update();
      return await _apiService.quizList(chapterId);
    } catch (e) {
      dev.log("Quiz list loading issue");
    } finally {
      loadingQuiz[chapterId] = false;
      update();
    }
    return [];
  }

  Future<void> quizResult(int chapterId) async => await _apiService.quizResult(chapterId.toString());


  Future<void> checkQuiz(String chapterId) async {
    bool value = await _apiService.checkResult(chapterId);
    quizSubmitted[chapterId] = RxBool(value);
  }

  Future<void> submitQuiz(Map<String, dynamic> data) async {
     await _apiService.submitQuestions(data).then((value) async => await checkQuiz(data["chapter_id"].toString()),);
  }

  Future<void> logout() async => _apiService.logout();
}