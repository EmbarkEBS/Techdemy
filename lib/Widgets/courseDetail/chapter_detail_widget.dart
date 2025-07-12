import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Screens/quiz/quiz.dart';
import 'package:tech/controllers/course_controller.dart';

class ChapterDetailWidget extends StatelessWidget {
  const ChapterDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: controller.courseDetail!.chapters.length,
        itemBuilder:(BuildContext context, int index) {
          ChapterDataPart chapterlist = controller.courseDetail!.chapters[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
            color: Colors.yellow.shade100,
            child: ExpansionTile(
              leading: const Icon(
                Icons.check,
                color: Colors.blue,
              ),
              title: Text(
                chapterlist.chapter_name,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              trailing: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () async {
                  await controller.quizList(chapterlist.chapter_id).then((value) {
                    Get.to(() => QuizScreen(chapterId: chapterlist.chapter_id, questions: value,));
                  },);
                },
                child: const Text(
                  'Quiz',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              children:  chapterlist.topic_data.isEmpty
              ? [
                const ListTile(
                    title: Text(
                      'No topics for this chapter',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ]
              : [
                for (var topics in chapterlist.topic_data.toString().trim().split("-")) 
                ...[
                  GestureDetector(
                    onTap: () {
                    },
                    child: ListTile(
                      dense: true,
                      tileColor: Colors.white,
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        topics,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.download,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ) 
                  ),
                ]
              ],
            )
          );
        },
      )
    );
  }
}