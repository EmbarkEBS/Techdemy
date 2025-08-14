import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/routes/routes.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseList course;
  const CourseCardWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return InkWell(
      onTap: () async {
         await controller.getCoursesDetail(course.courseId.toString(), course.name).then((value) async {
        },);
      },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0)
        ),
        elevation: 0,
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: 100,
                child: GetBuilder<CourseController>(
                  id: "courseDetail",
                  builder: (ctr) {
                    return Stack(
                      children: [
                        // Course image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: course.image,
                            errorWidget: (context, url, error) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200
                                ),
                                child: const Center(
                                  child: Icon(Icons.error),
                                ),
                              );
                            },
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
                          ),
                        ),
                        // loading indicator only if the course detail is loading
                        ctr.isCourseDetailLoading[course.courseId.toString()] != null && ctr.isCourseDetailLoading[course.courseId.toString()]!
                        ? const Center(
                          child: CircularProgressIndicator(),
                        )
                        : const SizedBox()
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(height: 10,),
               Text(
                course.name,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                course.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                course.price != "Free" ? "₹${course.price}" : course.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CourseTileWidget extends StatelessWidget {
  final CourseList course;
  const CourseTileWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return ListTile(
      onTap: () async {
         await controller.getCoursesDetail(course.courseId.toString(), course.name).then((value) async {
          // bool status = await controller.checkEnroll(course.courseId);
          // await controller.getCompletedChapters(course.courseId.toString());
          // Get.toNamed(AppRoutes.courseDetail, arguments: {"isEnrolled": status, "title": course.name});
        },);
      },
      leading: SizedBox(
        height: 70,
        width: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: course.image,
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
        ),
      ),
      title: Text(
        course.name,
        style: const TextStyle(
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.description,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              color: Colors.black26
            ),
          ),
          Text(
            course.price != "Free" ? "₹${course.price}" : course.price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}