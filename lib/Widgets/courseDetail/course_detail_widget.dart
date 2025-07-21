import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Screens/code_editor.dart';
import 'package:tech/controllers/course_controller.dart';

class CourseDetailWidget extends StatelessWidget {
  const CourseDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return  SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 5.0, 
            children: [
              if(controller.courseDetail!.courseDetailPart.tagData.isNotEmpty)
                for (var tag in controller.courseDetail!.courseDetailPart.tagData.toString().trim().split("-")) 
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
                    autofocus: true,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  )
                ],
            ]
          ),
          const SizedBox(height: 8,),
          Text(
            controller.courseDetail!.courseDetailPart.description.toString(),
            maxLines: controller.descTextShowFlag ? 2 : 15,
          ),
          InkWell(
            onTap: () {
              controller.selectDesc(!controller.descTextShowFlag);
            },
            child: Column(
              children: <Widget>[
                controller.descTextShowFlag
                  ? const Text("Show More",style: TextStyle(color: Colors.blue),)
                  : const Text("Show Less",style: TextStyle(color: Colors.blue))
              ],
            ),
          ),
          _detailTile(icon: Icons.menu_book_sharp, title: "Lessons",),
          _detailTile(icon: Icons.timelapse, title: "Duration",),
          _detailTile(icon: Icons.translate, title: "English",),
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
        ],
      ),
      //),
    );
  }

  Widget _detailTile({required IconData icon, required String title, Widget? trailing}) {
    return ListTile(
      onTap: (){},
      minTileHeight: 20,
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing
    );
  }
}