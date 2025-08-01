import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutCourseWidget extends StatelessWidget {
  const AboutCourseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Course", style: TextStyle(fontSize: 18),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(args ?? ""),
      ),
    );
  }
}