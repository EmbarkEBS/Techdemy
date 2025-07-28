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
                height: kToolbarHeight - 6,
                onDestinationSelected: (value) async {
                  if(controller.currentIndex == 2 && profileController.profile == null) {
                    await profileController.getProfile("home");
                  }
                  controller.changeIndex(value);
                },
                selectedIndex: controller.currentIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home), 
                    label: ""
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.menu_book_sharp), 
                    label: ""
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_circle_rounded), 
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