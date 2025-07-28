import 'package:get/get.dart';
import 'package:tech/controllers/auth_controller.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/controllers/home_controller.dart';
import 'package:tech/controllers/profile_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    // If I put fenix : false it will not create the Controller when it disposed
    Get.lazyPut(() => CourseController(), fenix: true);
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => CourseController(), fenix: true);
  }
}

