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
              if(controller.courseDetail!.courseDetailPart.tag_data.isNotEmpty)
                for (var tag in controller.courseDetail!.courseDetailPart.tag_data.toString().trim().split("-")) 
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
          const SizedBox(height: 20,),
          const Row(
            children: [
              Icon(Icons.menu_book_sharp),
              SizedBox(width: 10,),
              Text("Lessons")
            ],
          ),
          const Row(
            children: [
              Icon(Icons.timelapse),
              SizedBox(width: 10,),
              Text("Duration")
            ],
          ),
          const Row(
            children: [
              Icon(Icons.translate),
              SizedBox(width: 10,),
              Text("English")
            ],
          ),
          const Row(
            children: [
              Icon(Icons.badge),
              SizedBox(width: 10,),
              Text("Certification")
            ],
          ),
          Row(
            children: [
              const Icon(Icons.picture_as_pdf),
              const SizedBox(width: 10,),
              const Text("Course Material"),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  disabledForegroundColor:Colors.transparent
                ),
                onPressed: () async {
                  await controller.downloadFile(controller.courseDetail!.courseDetailPart.courseMaterial, controller.courseDetail!.courseDetailPart.name);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download,
                      size: 16,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 3,),
                    Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                )
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.comment_sharp),
              const SizedBox(width: 10,),
              const Text("Try code"),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeEditorPage(),)),
                icon: const Icon(
                  Icons.code,
                  size: 16,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ],
      ),
      //),
    );
  }
}