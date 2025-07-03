import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/controllers/profile_controller.dart';
import 'package:tech/routes/routes.dart';

class DrawerWidget extends StatelessWidget {
  final bool? isProfile;
  final bool? isMyCourse;
  final String? profileCaller;
  const DrawerWidget({super.key, this.isMyCourse, this.isProfile, this.profileCaller});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return  Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.yellow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                "assets/images/Techdemy-logo-onboarding.png",
                width: 50,
                height: 50,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white12,
              overlayColor: Colors.transparent.withValues(alpha: 0.43),
            ),
            onPressed: () async {
              Navigator.pop(context);
              if(isProfile == null) {
                controller.profile == null 
                ? await controller.getProfile(profileCaller ?? "drawer").then((value) => Get.toNamed(AppRoutes.profile),)
                : Get.toNamed(AppRoutes.profile);
              }
            },
            label: const Text('My Profile', style: TextStyle(color: Colors.black),),
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.black,
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white12,
              overlayColor: Colors.transparent.withValues(alpha: 0.43),
            ),
            onPressed: () async {
              Navigator.pop(context);
              isMyCourse != null ? null : Get.toNamed(AppRoutes.mycourses);
            },
            icon: const Icon(
              Icons.menu_book_sharp,
              color: Colors.black,
            ),
            label: const Text('My Courses', style: TextStyle(color: Colors.black)),
          ),
          // FilledButton.icon(
          //   style: FilledButton.styleFrom(
          //     backgroundColor: Colors.white12,
          //     overlayColor: Colors.transparent.withValues(alpha: 0.43),
          //   ),
          //   icon: const Icon(
          //     Icons.logout,
          //     color: Colors.black,
          //   ),
          //   label: const Text('Logout', style: TextStyle(color: Colors.black)),
          //   onPressed: () async {
          //     Get.find<AuthController>().logout();
          //   },
          // ),
        ],
      ),
    );
  }
}