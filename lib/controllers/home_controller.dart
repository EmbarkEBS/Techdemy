import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tech/Screens/home_page.dart';
import 'package:tech/Screens/mycourses_page.dart';
import 'package:tech/Screens/myprofile_page.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  void changeIndex(int value) {
    currentIndex = value;
    update();
  }

  List<Widget> screens = const [
    HomePage(),
    MyCoursesPage(),
    MyProfilePage()
  ];
}