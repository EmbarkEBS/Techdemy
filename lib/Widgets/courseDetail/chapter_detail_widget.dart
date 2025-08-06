import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/coursedetail_model.dart';
import 'package:tech/Screens/quiz/quiz.dart';
import 'package:tech/Widgets/courseDetail/topic_detail_widget.dart';
import 'package:tech/controllers/course_controller.dart';

class ChapterDetailWidget extends StatelessWidget {
  final bool isEnrolled;
  const ChapterDetailWidget({super.key, required this.isEnrolled});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: controller.courseDetail!.chapters.length,
        itemBuilder:(BuildContext context, int index) {
          ChapterDataPart chapterlist = controller.courseDetail!.chapters[index];
          return ExpansionTile(
            dense: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
            collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
            // leading: SizedBox(
            //   width: 15,
            //   child: Text("${index + 1}")),
            title: Row(
              // spacing: 8.0,
              children: [
                controller.completedChapters.any((element) => element.id == chapterlist.chapterId)
                ? const Icon(
                    Icons.check_circle_outline, 
                    color: Colors.green,
                    size: 18,
                  )
                : const SizedBox(),
                Text(
                  chapterlist.chapterName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
           children: [
              if (chapterlist.topicData.isEmpty)
                const Center(
                  child: Text(
                    'No topics found for this chapter',
                  ),
                )
              else
                ...chapterlist.topicData
                  .map(
                    (topic) => ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      leading: const Icon(Icons.menu_open_outlined, size: 16,),
                      onTap: () => Get.to(() => TopicDetailWidget(title: topic.topicTitle, content: topic.topicDescription)),
                      trailing: IconButton(
                        onPressed: () {}, 
                        icon: const Icon(Icons.arrow_forward_ios, size: 15,)
                      ),
                      title: Text(topic.topicTitle, style: const TextStyle(fontSize: 16,),),
                      subtitle: const Text("Contains topic file"),
                      // trailing: SizedBox(
                      //   height: 20,
                      //   width: 20,
                      //   child: Switch.adaptive(
                      //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //     value: false, 
                      //     onChanged: (value) {
                            
                      //     },
                      //   ),
                      // ),
                    ),
                  ),
            isEnrolled
              ? Obx(() {
                final submitted = controller.quizSubmitted[chapterlist.chapterId.toString()]?.value ?? false;
                return ListTile(
                  dense: true,
                  leading: const Icon(CupertinoIcons.bolt, size: 14,),
                  trailing: controller.loadingQuiz[chapterlist.chapterId] ?? false
                    ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : submitted
                      ? const Icon(Icons.check_circle_outline, color: Colors.green, size: 14,)
                      : null,
                  title: const Text(
                    // submitted ? 'View result' :
                    'Quiz',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  subtitle: Text(
                    "Quiz - ${chapterlist.quizCount} quiestions"
                  ),
                  onTap: () async {
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
                );
              },)
              : const SizedBox(),
            ],
          );
        },
      )
    );
  }

}