import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:tech/controllers/auth_controller.dart';

import '../Helpers/validator.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Image(
                    height: size.height * 0.2,
                    image: const AssetImage(
                      "assets/images/techdemy_logo.png",
                    )
                  ),
                  const Text(
                    'Get On Board!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    'Create your profile to start your journey',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Form(
                    key: controller.registerFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.registerNamecontroller,
                          validator: (value) => FieldValidator.validateFullname(value!),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            //labelText: 'Email',
                            hintText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: controller.registerEmailcontroller,
                          validator: (value) => FieldValidator.validateEmail(value!),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: controller.registerMobilecontroller,
                          keyboardType: TextInputType.number,
                          validator: (value) =>FieldValidator.validateMobile(value!),
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                            decoration: const InputDecoration(
                            counterText: '',
                            prefixIcon: Icon(Icons.phone_android),
                            //labelText: 'Email',
                            hintText: 'Mobile number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        DropdownButtonFormField(
                          value: controller.gender,
                          validator: (value) {
                            if (value == null || value == "Gender") {
                              return 'Please select gender';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          items: controller.genders.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (value) {
                           controller.selectGender(value ?? controller.gender);
                          }
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: controller.registerAddresscontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            //labelText: 'Email',
                            hintText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        DropdownButtonFormField<String>(
                          value: controller.usercategory,
                          validator: (value) {
                            if (value == null || value == "Select Type") {
                              return 'Please select type';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          items: controller.userCategories.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (value) {
                           controller.selectCategory(value ?? controller.usercategory);
                          }
                        ),
                        const SizedBox(height: 10,),
                        if (controller.usercategory == controller.userCategories[1])
                          Column(
                            spacing: 10,
                            children: [
                              TextFormField(
                                controller: controller.registerCollegecontroller,
                                validator: (value) => FieldValidator.validateCollegeName(value!),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.short_text),
                                  //labelText: 'Email',
                                  hintText: 'College name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              TextFormField(
                                controller: controller.registerDepartmentcontroller,
                                validator: (value) => FieldValidator.validateDepartment(value!),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.book),
                                  //labelText: 'Email',
                                  hintText: 'Department',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              DropdownButtonFormField(
                                value: controller.studentyear,
                                validator: (value) {
                                  if (value == null || value == "Select Year") {
                                    return 'Please select year';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                items: controller.years.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectStudentYear(value ?? controller.studentyear);
                                }
                              )
                            ],
                          ),
                        if (controller.usercategory == controller.userCategories[2])
                          DropdownButtonFormField(
                            value: controller.experiencelevel,
                            validator: (value) {
                              if (value == null ||
                                  value == "Select experience level") {
                                return 'Please select experience level';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            items: controller.experiencelevels.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.selectExperience(value ?? controller.experiencelevel);
                            }
                          ),
                        const SizedBox(height: 10,),
                        // ignore: unnecessary_null_comparison
                        if(controller.registerMessage.isNotEmpty)
                          Text(
                              controller.registerMessage["status"] == "success"
                              ? controller.registerMessage["message"] ?? "Registered successfully"
                              : controller.registerMessage["message"] ?? "Something went wrong",
                              style: TextStyle(
                                color: controller.registerMessage["status"] == "success" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                        const SizedBox(height: 10,),
                        GetBuilder<AuthController>(
                          id: "registering",
                          builder: (ctr) {
                            return FilledButton(
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
                                if(controller.registerFormKey.currentState!.validate()) {
                                  await controller.register();
                                }
                              },
                              child: ctr.isRegistering
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                )
                              : const Text('Register', style: TextStyle(color: Colors.yellow)),
                            );
                          }
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an account?",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                              child: const Text(
                                "Login",
                                textAlign: TextAlign.start,
                              )
                            )
                          ],
                        ),
                      ],
                    )
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
