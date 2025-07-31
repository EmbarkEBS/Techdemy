import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Screens/code_editor.dart';
import 'package:tech/controllers/course_controller.dart';

class CourseDetailWidget extends StatelessWidget {
  const CourseDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: GetBuilder<CourseController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8,),
              // Text(
              //   controller.courseDetail!.courseDetailPart.description.toString(),
              //   maxLines: controller.descTextShowFlag ? 2 : 15,
              // ),
              // InkWell(
              //   onTap: () {
              //     controller.selectDesc(!controller.descTextShowFlag);
              //   },
              //   child: Column(
              //     children: <Widget>[
              //       controller.descTextShowFlag
              //         ? const Text("Show More",style: TextStyle(color: Colors.blue),)
              //         : const Text("Show Less",style: TextStyle(color: Colors.blue))
              //     ],
              //   ),
              // ),
              _detailTile(
                icon: Icons.menu_book_sharp, 
                title: "Curriculam", 
                subtitle: "${controller.courseDetail!.chapters.length.toString()} lessons . ${controller.courseDetail!.courseDetailPart.duration}"
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
              _detailTile(icon: Icons.more_horiz, title: "About this course"),
            ],
          );
        }
      ),
    );
  }

  Widget _detailTile({required IconData icon, required String title, Widget? trailing, String? subtitle}) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      onTap: (){},
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