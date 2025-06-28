import 'package:get/get.dart';
import 'package:tech/controllers/auth_controller.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/controllers/profile_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseController(), fenix: false);
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: false);
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(), fenix: false);
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(), fenix: false);
    Get.lazyPut(() => CourseController(), fenix: false);
  }
}

