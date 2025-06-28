import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/Screens/code_editor.dart';
import 'package:tech/Screens/quiz/quiz.dart';
import 'package:tech/controllers/course_controller.dart';

import '../Models/coursedetail_model.dart';


class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Course Details"),
        surfaceTintColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: controller.courseDetail != null
          ? NestedScrollView(
              headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    surfaceTintColor: Colors.transparent,
                    snap: false,
                    toolbarHeight: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image(
                        height: 100,
                        width: 100,
                        image: NetworkImage(controller.courseDetail!.courseDetailPart.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                    /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                ),*/
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      color: Colors.white,
                      //alignment: Alignment.center,
                      height: 130,
                      child: Column(
                        //padding: EdgeInsets.all(2),
                        //shrinkWrap: true,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Text(
                            controller.courseDetail!.courseDetailPart.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            controller.courseDetail!.courseDetailPart.duration,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 5,),
                          FilledButton(
                            onPressed: () async {
                              await controller.enrollCourse(controller.courseDetail!.courseDetailPart.course_id.toString());
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                              minimumSize: const Size(double.infinity, 40)
                            ),
                            child: const Text('Start now',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: MySliverPersistentHeaderDelegate(
                      ButtonsTabBar(
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle:const TextStyle(color: Colors.blue),
                        labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                        backgroundColor: Colors.yellow,
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        tabs: const [
                          Tab(
                            child: Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.black
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Lessons",
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 5.0, 
                          children: [
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
                  ),
                  Container(
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(question: quizQuestions, ),));
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
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            )
          ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final ButtonsTabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      //color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    id: 1,
    question: "What is the capital of France?",
    options: ["Paris", "London", "Rome"],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    id: 2,
    question: "Which planet is known as the Red Planet?",
    options: ["Earth", "Mars", "Jupiter"],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 3,
    question: "Who wrote 'Hamlet'?",
    options: ["Shakespeare", "Tolkien", "Dickens"],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    id: 4,
    question: "What is the boiling point of water?",
    options: ["90°C", "100°C", "110°C", "120°C"],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 5,
    question: "What is 5 + 7?",
    options: ["10", "11", "12", "13"],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    id: 6,
    question: "What color do you get when you mix red and white?",
    options: ["Pink", "Purple", "Orange"],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    id: 7,
    question: "Which ocean is the largest?",
    options: ["Atlantic", "Pacific", "Indian"],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 8,
    question: "Who painted the Mona Lisa?",
    options: ["Michelangelo", "Leonardo da Vinci", "Raphael"],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    id: 9,
    question: "How many continents are there?",
    options: ["5", "6", "7"],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    id: 10,
    question: "Which gas do plants absorb?",
    options: ["Oxygen", "Carbon Dioxide", "Nitrogen"],
    correctAnswerIndex: 1,
  ),
];
