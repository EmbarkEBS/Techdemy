import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Screens/code_editor.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/routes/routes.dart';

class CourseDetailWidget extends StatelessWidget {
  const CourseDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(
      builder: (controller) {
        int topicsCount = controller.courseDetail!.chapters.fold(0, (previousValue, element) => previousValue + element.topicCount);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailTile(
                icon: Icons.menu_book_sharp, 
                title: "Curriculam", 
                subtitle: "${controller.courseDetail!.chapters.length.toString()} lessons . $topicsCount topics . ${controller.courseDetail!.courseDetailPart.duration}"
              ),
              // _detailTile(icon: Icons.timelapse, title: "Duration",),
              _detailTile(icon: Icons.translate, title: "Language", subtitle: "English"),
              _detailTile(icon: Icons.badge, title: "Certification",),
              _detailTile(
                icon: Icons.picture_as_pdf, 
                title: "Course material", 
                trailing: IconButton(
                  onPressed: () async {
                    await controller.downloadFile(controller.courseDetail!.courseDetailPart.courseMaterial, controller.courseDetail!.courseDetailPart.name);
                  },
                  icon: const Icon(
                    Icons.download,
                    size: 16,
                    color: Colors.blue,
                  )
                )
              ),
              _detailTile(
                icon: Icons.comment_sharp, 
                title: "Try code", 
                trailing:  IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeEditorPage(),)),
                  icon: const Icon(
                    Icons.code,
                    size: 16,
                    color: Colors.blue,
                  ),
                )
              ),
              _detailTile(icon: Icons.more_horiz, title: "About this course", onTap: () => Get.toNamed(AppRoutes.aboutCourse, arguments: controller.courseDetail!.courseDetailPart.description)),
            ],
          ),
        );
      }
    );
  }

  Widget _detailTile({
    required IconData icon, 
    required String title, 
    Widget? trailing,
    String? subtitle,
    VoidCallback? onTap
  }) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      onTap: onTap ?? () {},
      minTileHeight: 20,
      contentPadding: EdgeInsets.zero,
      // dense: true,
      title: Text(title, style: const TextStyle(fontSize: 14),),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12),) : null,
      leading: Icon(icon),
      trailing: trailing
    );
  }
}