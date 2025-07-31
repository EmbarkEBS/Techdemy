import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/courselist_model.dart';
import 'package:tech/Screens/coursedetails_page.dart';
import 'package:tech/controllers/course_controller.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseList course;
  const CourseCardWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return InkWell(
      onTap: () async {
         await controller.getCoursesDetail(course.courseId.toString()).then((value) async {
          bool status = await controller.checkEnroll(course.courseId);
          Get.to(() => CourseDetailsScreen(isEnrolled: status));
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
            spacing: 10,
            children: [
              const SizedBox(height: 0,),
              SizedBox(
                height: 100,
                child: ClipRRect(
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
              ),
               Text(
                "${course.name} Testing second line",
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                course.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "₹${course.price}",
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