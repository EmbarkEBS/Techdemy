import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:learningapp_flutter/Screens/courseslist_page.dart';
import 'package:learningapp_flutter/Screens/mycourse_page.dart';
import 'package:learningapp_flutter/Screens/myprofile_page.dart';
import 'package:learningapp_flutter/Screens/otpverification_page.dart';

import 'Models/courseslist_model.dart';
import 'Screens/coursedetails_page.dart';
import 'Screens/login_page.dart';
import 'Screens/onboarding_page.dart';
import 'Screens/signup_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize();
  /*FlutterDownloader.registerCallback((id, status, progress) {

  });*/
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
      routes: {
        '/login':(context)=>LoginPage(),
        '/signup':(context)=>SignUpPage(),
        '/verification':(context)=>OTPVerificationPage(),
        //'/homepage':(context)=>NewsListPage(title: 'news',newsType: 'sports',),
        '/homepage':(context)=>HomePage(title: 'course details',),
        //'/coursedetails':(context)=>CourseDetails(),
        '/mycourses':(context)=>MyCoursesPage(),
       // '/myprofile':(context)=>MyProfilePage(),
      },
    );
  }
}
