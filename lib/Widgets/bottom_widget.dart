import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/controllers/home_controller.dart';
import 'package:tech/controllers/profile_controller.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: controller.screens[controller.currentIndex],
          bottomNavigationBar: GetBuilder<ProfileController>(
            builder: (profileController) {
              return NavigationBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                indicatorColor: Colors.transparent,
                height: kToolbarHeight - 6,
                onDestinationSelected: (value) async {
                  controller.changeIndex(value);
                  // if(controller.currentIndex == 2 && profileController.profile == null) {
                  //   Future.wait([
                  //     profileController.getProfile("home")
                  //   ]);
                  // }
                },
                selectedIndex: controller.currentIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: [
                  NavigationDestination(
                    icon: Icon(controller.currentIndex == 0 ? Icons.home : Icons.home_outlined), 
                    label: ""
                  ),
                  NavigationDestination(
                    icon: Icon(controller.currentIndex == 1 ? Icons.play_circle : Icons.play_circle_outline), 
                    label: ""
                  ),
                  NavigationDestination(
                    icon: Icon(controller.currentIndex == 2 ? Icons.account_circle_rounded : Icons.account_circle_outlined), 
                    label: ""
                  ),
                ]
              );
            }
          ),
        );
      }
    );
  }
}