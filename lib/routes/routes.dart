import 'package:get/get_navigation/get_navigation.dart';
import 'package:tech/Screens/coursedetails_page.dart';
import 'package:tech/Screens/home_page.dart';
import 'package:tech/Screens/login_page.dart';
import 'package:tech/Screens/mycourses_page.dart';
import 'package:tech/Screens/myprofile_page.dart';
import 'package:tech/Screens/onboarding_page.dart';
import 'package:tech/Screens/otpverification_page.dart';
import 'package:tech/Screens/quiz/quiz.dart';
import 'package:tech/Screens/signup_page.dart';
import 'package:tech/Widgets/bottom_widget.dart';
import 'package:tech/Widgets/courseDetail/about_course_widget.dart';
import 'package:tech/Widgets/edit_profile_widget.dart';
import 'package:tech/bindings/bindings.dart';

class AppRoutes {
  static const onBoarding = "/onBoarding";
  static const login = "/login";
  static const signup = "/signup";
  static const verification = "/verification";
  static const homepage = "/homepage";
  static const courseDetail = "/courseDetail";
  static const mycourses = "/mycourses";
  static const quiz = "/quiz";
  static const profile = "/profile";
  static const bottom = "/bottom";
  static const editProfile = "/editProfile";
  static const aboutCourse = "/aboutCourse";
}

class AppScreens {
  // static final bindings = AppBindings();
  static final screens = [
    GetPage(
      name: AppRoutes.bottom, 
      page: () => const BottomWidget(),
    ),
    GetPage(
      name: AppRoutes.onBoarding, 
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.login, 
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup, 
      page: () => const SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verification, 
      page: () => const OTPVerificationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.homepage, 
      page: () => const HomePage(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: AppRoutes.quiz, 
      page: () => const QuizScreen(chapterId: 0, questions: [], timer: 0, courseId: 0,),
      binding: CourseBinding(),
    ),
    GetPage(
      name: AppRoutes.mycourses, 
      page: () => const MyCoursesPage(),
      binding: ProfileBinding()
    ),
    GetPage(
      name: AppRoutes.courseDetail, 
      page: () => const CourseDetailsScreen(),
      binding: CourseBinding(),
      // arguments: {"isEnrolled": false, "title": "Course detail"}
    ),
    GetPage(
      name: AppRoutes.profile, 
      page: () => const MyProfilePage(),
      binding: ProfileBinding()
    ),
    GetPage(
      name: AppRoutes.editProfile, 
      page: () => const EditProfileWidget(),
      binding: ProfileBinding()
    ),
    GetPage(
      name: AppRoutes.aboutCourse, 
      page: () => const AboutCourseWidget(),
    )
  ];
}
