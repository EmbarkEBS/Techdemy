import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/Helpers/validator.dart';
import 'package:tech/controllers/profile_controller.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
 
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.home,
              size: 30,
              // color: Colors.white,
            )
          ),
        ],
      ),
      drawer: Drawer(
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
                Navigator.pushNamed(context, "/mycourses");
              },
              icon: const Icon(
                Icons.menu_book_sharp,
                color: Colors.black,
              ),
              label: const Text('My Courses', style: TextStyle(color: Colors.black)),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white12,
                overlayColor: Colors.transparent.withValues(alpha: 0.43),
              ),
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              label: const Text('Logout', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                //Navigator.pushNamed(context, "/mycourses");
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setInt("user_id", 0);
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
     
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20,),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      enabled: controller.isEnabled,
                      controller: controller.namecontroller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        //labelText: 'Email',
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      enabled: controller.isEnabled,
                      controller: controller.emailcontroller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline),
                        //labelText: 'Email',
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) {
                      //   email = value;
                      // },
                      validator: (value) => FieldValidator.validateEmail(value ?? ""),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      enabled: controller.isEnabled,
                      controller: controller.mobilecontroller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_android),
                        //labelText: 'Email',
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) {
                      //   mobile = value;
                      // },
                    ),
                    const SizedBox(height: 10,),
                    DropdownButtonFormField(
                      value: controller.gender,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: controller.items1.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: controller.isEnabled
                        ? (String? newValue) {
                            controller.selectGender(newValue ?? controller.gender);
                          }
                        : null
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      enabled: controller.isEnabled,
                      controller: controller.addresscontroller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        hintText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      // onChanged: (value) {
                      //   address = value;
                      // },
                    ),
                    const SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                      hint: Text(controller.usercategory),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: controller.items2.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged:null
                    ),
                    const SizedBox(height: 10,),
                    if (controller.usercategory == controller.items2[1])
                      Column(
                        children: [
                          TextFormField(
                            enabled: controller.isEnabled,
                            controller: controller.collegecontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.short_text),
                              //labelText: 'Email',
                              hintText: 'College Name',
                              border: OutlineInputBorder(),
                            ),
                            // onChanged: (value) {
                            //   collegename = value;
                            // },
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            enabled: controller.isEnabled,
                            controller: controller.departmentcontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.book),
                              //labelText: 'Email',
                              hintText: 'Department',
                              border: OutlineInputBorder(),
                            ),
                            // onChanged: (value) {
                            //   department = value;
                            // },
                          ),
                        const SizedBox(height: 10,),
                          DropdownButtonFormField(
                            value: controller.studentyear,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            items: controller.items3.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: controller.isEnabled
                              ? (String? newValue) {
                                  controller.selectStudentYear(newValue ?? controller.studentyear);
                                }
                              : null
                          ),
                        ],
                      ),
                    if (controller.usercategory == controller.items2[2])
                      DropdownButtonFormField(
                        hint: Text(controller.experiencelevel),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: controller.items4.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: controller.isEnabled
                          ? (String? newValue) {
                              controller.selectExperience(newValue ?? controller.experiencelevel);
                            }
                          : null
                      ),
                    const SizedBox(height: 10,),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Colors.black)
                        ),
                        minimumSize: const Size(double.infinity, 50)
                      ),
                      onPressed: () async {
                        if (!controller.isEnabled) {
                          setState(() {
                            controller.isEnabled = true;
                          });
                        } else {
                          if (controller.formKey.currentState!.validate()) {
                            await controller.updateProfile();
                          }
                        }
                      },
                      child: Text(controller.isEnabled ? 'UPDATE' : 'EDIT NOW'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
