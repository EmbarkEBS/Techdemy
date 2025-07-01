import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tech/Helpers/validator.dart';
import 'package:tech/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Image(
                      height: size.height * 0.2,
                      image: const AssetImage(
                        "assets/images/Techdemy_logo1.png",
                      )
                    ),
                    const Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'Make it work, make it right, make it last',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Form(
                      key: controller.loginFormKey,
                      child: Column(
                      children: [
                        TextFormField(
                          controller: controller.loginController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                          decoration: const InputDecoration(
                            counterText: '',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            //labelText: 'Email',
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => FieldValidator.validateMobile(value!),
                        ),
                        const SizedBox(height: 10,),
                        if(controller.loginMessage.isNotEmpty)
                          Text(
                              controller.loginMessage["status"] == "success"
                              ? controller.loginMessage["message"] ?? "Registered successfully"
                              : controller.loginMessage["message"] ?? "Something went wrong",
                              style: TextStyle(
                                color: controller.loginMessage["status"] == "success" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                            ),
                        const SizedBox(height: 10,),
                        GetBuilder<AuthController>(
                          builder: (ctr2) {
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
                                // controller.deviceID();
                                if (controller.loginFormKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  await ctr2.login();
                                }
                              },
                              child: ctr2.isLoggingIn 
                              ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.yellow,
                                  ),
                                ),
                              )
                              : const Text('Login', style: TextStyle(color: Colors.yellow),),
                            );
                          }
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                controller.notificationService.notificationPermission();
                                Navigator.pushReplacementNamed(context, '/signup');
                              },
                              child: const Text(
                                "Signup",
                                textAlign: TextAlign.start,
                              )
                            )
                          ],
                        ),
                      ],
                    ))
                  ],
                )
              ),
            ),
          );
        }
      ),
    );
  }
}
