import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/Widgets/courseDetail/chapter_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/course_detail_widget.dart';
import 'package:tech/controllers/course_controller.dart';


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
              body: const TabBarView(
                children: [
                  CourseDetailWidget(),
                  ChapterDetailWidget()
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
