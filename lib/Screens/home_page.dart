import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Widgets/drawer_widget.dart';
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
      drawer: const DrawerWidget(profileCaller: "Home screen",),
      body: FutureBuilder<List<CourseList>>(
        future: controller.getCoursesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CourseList> courses = snapshot.data!;
            return ListView.separated(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  CourseList courselist = courses[index];
                  if (controller.selectedCategory == 'All' || controller.selectedCategory == courselist.name) {
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
                          GetBuilder<CourseController>(
                            id: 'enroll_${courselist.course_id.toString()}',
                            builder: (ctr2) {
                              return FilledButton(
                                onPressed: () async {
                                  await ctr2.enrollCourse(courselist.course_id.toString()).then((value) {
                                    Get.toNamed(AppRoutes.mycourses);
                                  },);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  minimumSize: const Size(double.infinity, 40)
                                ),
                                child: ctr2.isEnrolling[courselist.course_id.toString()] != null 
                                  && ctr2.isEnrolling[courselist.course_id.toString()]!
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  )
                                : const Text(
                                  'Start Now',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              );
                            }
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
