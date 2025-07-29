import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Helpers/validator.dart';
// import 'package:tech/Widgets/drawer_widget.dart';
import 'package:tech/controllers/profile_controller.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',),
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
      body: GetBuilder<ProfileController>(
        id: "profile",
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    // autovalidateMode: controller.profile != null ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // User name
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: controller.isEnabled,
                          textInputAction: TextInputAction.next,
                          controller: controller.namecontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            //labelText: 'Email',
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => FieldValidator.validateFullname(value!),
                          // onChanged: (value) => name = value,
                        ),
                        const SizedBox(height: 10,),
                        // User email
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          enabled: controller.isEnabled,
                          controller: controller.emailcontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                            //labelText: 'Email',
                            hintText: 'Email',
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            border: OutlineInputBorder(),
                          ),
                          // onChanged: (value) {
                          //   email = value;
                          // },
                          validator: (value) => FieldValidator.validateEmail(value ?? ""),
                        ),
                        const SizedBox(height: 10,),
                        // User mobile number
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          enabled: controller.isEnabled,
                          controller: controller.mobilecontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            //labelText: 'Email',
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            hintText: 'Mobile Number',
                            border: OutlineInputBorder(),
                          ),
                          // onChanged: (value) {
                          //   mobile = value;
                          // },
                        ),
                        const SizedBox(height: 10,),
                        // User gender
                        DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          value: controller.gender,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: controller.isEnabled ? Colors.black: Colors.black12,),
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: controller.isEnabled ? Colors.black: Colors.black12)
                            )
                          ),
                          items: controller.items1.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value == "Gender") {
                              return 'Please select gender';
                            }
                            return null;
                          },
                          onChanged: controller.isEnabled
                            ? (String? newValue) {
                                controller.selectGender(newValue ?? controller.gender);
                              }
                            : null
                        ),
                        const SizedBox(height: 10,),
                        // User address
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          enabled: controller.isEnabled,
                          controller: controller.addresscontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            hintText: 'Address',
                            focusedBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            border: OutlineInputBorder(),
                          ),
                          // onChanged: (value) {
                          //   address = value;
                          // },
                        ),
                        const SizedBox(height: 10,),
                        // user type
                        DropdownButtonFormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          hint: Text(controller.usercategory, style: TextStyle(color: controller.isEnabled ? Colors.black : Colors.black26),),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: controller.isEnabled ? Colors.black: Colors.black12,),
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(),
                            errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: controller.isEnabled ? Colors.black: Colors.black12)
                            )
                          ),
                          items: controller.items2.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged:null
                        ),
                        // If user is student
                        const SizedBox(height: 10,),
                        if (controller.usercategory == controller.items2[1])
                          Column(
                            children: [
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                enabled: controller.isEnabled,
                                controller: controller.collegecontroller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.short_text),
                                  //labelText: 'Email',
                                  hintText: 'College Name',
                                  focusedBorder:  OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                  border: OutlineInputBorder(),
                                ),
                                // onChanged: (value) {
                                //   collegename = value;
                                // },
                              ),
                              const SizedBox(height: 10,),
                                TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: controller.isEnabled,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: controller.departmentcontroller,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.book),
                                  //labelText: 'Email',
                                  hintText: 'Department',
                                  focusedBorder: const OutlineInputBorder(),
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                  border: controller.isEnabled 
                                  ? const OutlineInputBorder() : null,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              DropdownButtonFormField(
                                value: controller.studentyear,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person, color: controller.isEnabled ? Colors.black: Colors.black12,),
                                  border: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(),
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: controller.isEnabled ? Colors.black: Colors.black12)
                                  )
                                ),
                                validator: (value) {
                                  if (value == null || value == "Select Year") {
                                    return 'Please select year';
                                  }
                                  return null;
                                },
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
                        // user if experience candidate
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            hint: Text(controller.experiencelevel),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: controller.isEnabled ? Colors.black: Colors.black12,),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: controller.isEnabled ? Colors.black: Colors.black12)
                              ),
                              focusedBorder: const OutlineInputBorder(),
                              errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent))
                            ),
                            items: controller.items4.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null ||
                                  value == "Select Experience Level" || controller.experiencelevel == "Select Experience Level") {
                                return 'Please select experience level';
                              }
                              return null;
                            },
                            onChanged: controller.isEnabled
                              ? (String? newValue) {
                                  controller.selectExperience(newValue ?? controller.experiencelevel);
                                }
                              : null
                          ),
                        const SizedBox(height: 10,),
                        GetBuilder<ProfileController>(
                          builder: (ctr2) {
                            return Column(
                              spacing: 10,
                              children: [
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
                                    if (controller.isEnabled) {
                                      if (controller.formKey.currentState!.validate()) {
                                        await controller.updateProfile().then((value) {
                                          controller.editProfile(!controller.isEnabled);
                                        },);
                                      }
                                    } else {
                                      controller.editProfile(!controller.isEnabled);
                                    }
                                  },
                                  child: ctr2.isEditing
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    )
                                  : Text(
                                    controller.isEnabled ? 'UPDATE' : 'EDIT NOW', 
                                    style: const TextStyle(color: Colors.yellow),
                                  ),
                                ),
                                controller.isEnabled 
                                 ? FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: const BorderSide(color: Colors.black)
                                      ),
                                      minimumSize: const Size(double.infinity, 50)
                                    ),
                                    onPressed: () => ctr2.cancelEdit(false), 
                                    child: const Text(
                                      "CANCEL", 
                                      // style: TextStyle(color: Colors.yellow),
                                    )
                                  )
                                : const SizedBox()
                              ],
                            );
                          }
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
