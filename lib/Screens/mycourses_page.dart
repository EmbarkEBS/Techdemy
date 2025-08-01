import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:tech/Widgets/mycourses/completed_courses.dart';
import 'package:tech/Widgets/mycourses/on_going_courses.dart';
// import 'package:tech/controllers/profile_controller.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses", style: TextStyle(fontSize: 18)),
        surfaceTintColor: Colors.transparent,
      ),
      // drawer: const DrawerWidget(isMyCourse: true, profileCaller: "Courses screen",),
      body: DefaultTabController(
        length: 2,
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TabBar(
                unselectedLabelStyle:const TextStyle(color: Colors.blue),
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.yellow)
                  ),
                tabs: const [
                  Tab(
                    child: Text(
                      "OnGoing",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: <Widget>[
                  OnGoingCourses(),
                  CompletedCourses()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}