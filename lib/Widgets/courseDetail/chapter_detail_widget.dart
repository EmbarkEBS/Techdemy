import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Screens/quiz/quiz.dart';
import 'package:tech/controllers/course_controller.dart';

class ChapterDetailWidget extends StatelessWidget {
  final bool isEnrolled;
  const ChapterDetailWidget({super.key, required this.isEnrolled});

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
              leading: const Icon(
                Icons.check,
                color: Colors.blue,
              ),
              title: Text(
                chapterlist.chapterName,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              trailing: isEnrolled
              ? Obx(() {
                final submitted = controller.quizSubmitted[chapterlist.chapterId.toString()]?.value ?? false;
                return TextButton(
                  style: TextButton.styleFrom(),
                  onPressed: () async {
                    if(submitted) {
                      await controller.quizResult(chapterlist.chapterId);
                    } else {
                      await controller.quizList(chapterlist.chapterId).then((value) {
                        Get.to(() => QuizScreen(
                          chapterId: chapterlist.chapterId, 
                          questions: value, 
                          timer: chapterlist.timer, 
                          courseId: controller.courseDetail!.courseDetailPart.courseId,
                        ));
                      },);
                    }
                  },
                  child: controller.loadingQuiz[chapterlist.chapterId] ?? false
                  ? const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Text(
                    submitted ? 'View result' :'Quiz',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                );
              },)
              : const SizedBox(),
              children:  chapterlist.topicData.isEmpty
              ? [
                const Center(
                    child: Text(
                      'No topics found for this chapter',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ]
              : [
                for (var topics in chapterlist.topicData.toString().trim().split("-")) 
                ...[
                  ListTile(
                    dense: true,
                    onTap: () {},
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