import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/controllers/profile_controller.dart';

class OnGoingCourses extends StatelessWidget {
  const OnGoingCourses({super.key});

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
              ? _loadOnGoingCourses(controller.mycourses)
              : FutureBuilder<List<MyCoursesList>>(
                future: controller.getMyCourses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MyCoursesList> courses = snapshot.data!;
                    bool haveCompletedCourses = courses.any((course) => course.courseStatus == "OnGoing");
                    return !haveCompletedCourses
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text("No on-going courses found")),
                        ],
                      )
                    : _loadOnGoingCourses(courses);
                  } else if (snapshot.hasError) {
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

  Widget _loadOnGoingCourses(List<MyCoursesList> courses) {
    List<MyCoursesList> onGoingCourses = courses.where((e) => e.courseStatus == "OnGoing",).toList();
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      //scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: onGoingCourses.length,
      itemBuilder:(context, index) {
        MyCoursesList coursesList = onGoingCourses[index];
        return InkWell(
          // onTap: () {},
          child: Column(
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
                        LinearProgressIndicator(
                          value: coursesList.percentage.isEmpty 
                            ? 0.0
                            : double.parse(coursesList.percentage) / 100,
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.225),
                child: Text(
                  "${coursesList.percentage}% completed"
                ),
              ),
            ],
          ),
        );
      
        // return const SizedBox();
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