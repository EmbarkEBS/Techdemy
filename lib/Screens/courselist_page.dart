import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/routes/routes.dart';

import '../Models/courselist_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        // backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
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
              onPressed: () async => await controller.getProfile().then((value) => Get.toNamed(AppRoutes.profile),),
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
                await sp.clear();
                controller.logout();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CourseList>>(
        future: controller.getCoursesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CourseList> courses = snapshot.data!;
            return ListView.separated(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  CourseList courselist = courses[index];
                  if (controller.selectedCategory == 'All' ||
                      controller.selectedCategory == courselist.name) {
                    return ListTile(
                      onTap: () async => await controller.getCoursesDetail(courselist.course_id.toString()).then((value) {
                        Get.toNamed(AppRoutes.courseDetail);
                      },),
                      leading: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 60,
                        child: Image.network(
                          courselist.image,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            courselist.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(courselist.duration),
                          const SizedBox(height: 10,),
                          Text(
                            courselist.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          FilledButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, "/mycourses",);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              minimumSize: const Size(double.infinity, 40)
                            ),
                            child: const Text(
                              'Start Now',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: courselist.tag_data.isEmpty
                      ? const SizedBox()
                      : Wrap(
                        spacing: 5.0,
                        children: [
                          for (var tag in courselist.tag_data.toString().trim().split("-")) 
                            ...[
                            Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              shadowColor: Colors.black54,
                              backgroundColor: Color.fromRGBO(
                                controller.random.nextInt(256),
                                controller.random.nextInt(256),
                                controller.random.nextInt(256),
                                controller.random.nextDouble()
                              ),
                              //elevation: 10,
                              autofocus: true,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            )
                          ],
                          // const SizedBox(width: 5,)s,
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: Colors.black26,
                  );
                },
              );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }


}
