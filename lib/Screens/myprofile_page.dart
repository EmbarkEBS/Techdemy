import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/controllers/home_controller.dart';
import 'package:tech/controllers/profile_controller.dart';
import 'package:tech/routes/routes.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontSize: 18),),
        surfaceTintColor: Colors.transparent,
        // actions: [
        //   IconButton(
        //     onPressed: () => Navigator.pop(context),
        //     icon: const Icon(
        //       Icons.home,
        //       size: 30,
        //       // color: Colors.white,
        //     )
        //   ),
        // ],
      ),
      // drawer: const DrawerWidget(isProfile: true, profileCaller: "Profile screen",),
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          return GetBuilder<ProfileController>(
            id: "profile",
            builder: (controller) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 120,
                          child: Image.asset(
                            "assets/images/user.png",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Text(
                        controller.namecontroller.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        controller.emailcontroller.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      const SizedBox(height: 40,),
                      _profileTile(
                        title: "Edit profile", 
                        leading: Icons.edit, 
                        onTap: () => Get.toNamed(AppRoutes.editProfile),
                      ),
                      const SizedBox(height: 15,),
                     _profileTile(
                        title: "My courses", 
                        leading: Icons.menu_open_outlined, 
                        onTap: () => homeController.changeIndex(homeController.currentIndex - 1)
                      ),
                      const SizedBox(height: 15,),
                     _profileTile(
                        title: "Explore courses", 
                        leading: Icons.explore_outlined, 
                        onTap: () => homeController.changeIndex(homeController.currentIndex - 2)
                      ),
                     
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }

  Widget _profileTile({
    required String title,
    required IconData leading,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      tileColor: Colors.yellow,
      leading: Icon(leading),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
