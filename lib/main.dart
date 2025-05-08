import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tech/Widgets/quiz_start_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Screens/courselist_page.dart';
import 'Screens/login_page.dart';
import 'Screens/mycourses_page.dart';
import 'Screens/onboarding_page.dart';
import 'Screens/otpverification_page.dart';
import 'Screens/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  WebViewPlatform.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/verification': (context) => const OTPVerificationPage(),
        '/homepage': (context) => const HomePage(title: 'course details',),
        '/quiz': (context) => QuizStartWidget(),
        '/mycourses': (context) => const MyCoursesPage(),
      },
    );
  }
}
