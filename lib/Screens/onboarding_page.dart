import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/routes/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      backgroundColor: Colors.yellow,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Image(
                width: 280,
                height: 300,
                image: AssetImage("assets/images/onboarding_logo.png",)
              ),
              const SizedBox(height: 100,),
              const Text(
                'Build Your Career',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.black,
                  wordSpacing: 1,
                  letterSpacing: 0.5
                ),
              ),
              const Text(
                "Let's put your creativity on \n the development highway",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  wordSpacing: 2,
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: const BorderSide(color: Colors.black)
                      ),
                      minimumSize: const Size(130, 45)
                    ),
                    onPressed: () async => Get.offNamed(AppRoutes.login),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: const BorderSide(color: Colors.black)
                      ),
                      minimumSize: const Size(130, 45)
                    ),
                    onPressed: () => Get.offNamed(AppRoutes.signup),
                    child: const Text(
                      'SIGNUP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
