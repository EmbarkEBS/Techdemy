import 'package:flutter/material.dart';

// import 'package:tech/Widgets/common_widgets.dart';
// import 'package:tech/Widgets/quiz_questions.dart';

import '../Models/quiz_question_model.dart';

// ignore: must_be_immutable
class QuizStartWidget extends StatelessWidget {
  QuizStartWidget({super.key,});

  List<QuizQuestions> samples = [];

  @override
  Widget build(BuildContext context) {
    return Container();
    // final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // samples = args['questions'];
    // return Scaffold(
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     title: const Text('Quiz'),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             commonHeading('Quiz | ${samples.length} Questions'),
    //             const SizedBox(height: 10,),
    //             const SizedBox(height: 10,),
    //             commonHeading('Chapter'),
    //             const SizedBox(height: 10,),
    //             Text(
    //               args['chapterName'],
    //               // style: const TextStyle(
    //               //     fontSize: 16, fontWeight: FontWeight.w500),
    //             ),
    //             const SizedBox(height: 10,),
    //             commonHeading('Description'),
    //             const SizedBox(height: 10,),
    //             Text(
    //               args['description'],
    //               // style: const TextStyle(
    //               //     fontSize: 16, fontWeight: FontWeight.w500),
    //             )
    //           ],
    //         ),
    //         // const Center(
    //         //   child: Text(
    //         //     "Let's Start",
    //         //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    //         //   ),
    //         // ),
    //         button(
    //           name: 'Start quiz',
    //           onPressed: () {
    //             Navigator.of(context).pushReplacement(MaterialPageRoute(
    //               builder: (context) => QuizQuestionPage(quesions: samples),
    //             ));
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
