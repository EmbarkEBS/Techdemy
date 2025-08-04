import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/controllers/profile_controller.dart';

class CompletedCourses extends StatelessWidget {
  const CompletedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async => await controller.getMyCourses(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
            ),
            child: controller.mycourses.isNotEmpty
            ? _loadCompletedCourses(courses: controller.mycourses)
            : controller.emptyCourses
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("No course completed yet")),
                  ],
                )
              : FutureBuilder<List<MyCoursesList>>(
                future: controller.getMyCourses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MyCoursesList> courses = snapshot.data!;
                    return _loadCompletedCourses(courses: courses,);
                  }  else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
          ),
        );
      }
    );
  }

  Widget _loadCompletedCourses({required List<MyCoursesList> courses}) {
    final controller = Get.find<ProfileController>();
    List<MyCoursesList> completedCourses = courses.where((e) => e.courseStatus == "Completed",).toList();
    bool haveCompletedCourses = courses.any((course) => course.courseStatus == "Completed");
    return !haveCompletedCourses
      ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("No Course Completed Yet")),
          ],
        )
      : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          itemCount: completedCourses.length,
          itemBuilder: (BuildContext context, int index) {
            MyCoursesList coursesList = completedCourses[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: 5,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: coursesList.image,
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover
                                )
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200
                              ),
                              child: const Center(
                                child: Icon(Icons.error),
                              ),
                            );
                          }
                        ),
                      )
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text(
                            coursesList.name,
                            style: const TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            coursesList.description,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black26,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          InkWell(
                            onTap: () async => await controller.downloadFile(coursesList.certificateFile, coursesList.certificateFile.split("/").last),
                            child: const Text('Download certificate'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                
              ],
            );
          },
          separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: Colors.black26,
              );
            },
        );
  }
}