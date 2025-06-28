// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tech/Widgets/common_widgets.dart';
import 'package:tech/Widgets/quiz_result_page.dart';

import '../Models/quiz_question_model.dart';

class QuizQuestionPage extends StatefulWidget {
  final List<QuizQuestions> quesions;
  const QuizQuestionPage({super.key, required this.quesions});

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  // ignore: unused_field
  late Timer _timer;
  int questionTime = 150;
  int selectedQuestion = 0;
  QuizQuestions? question;
  Color? selectedTileColor;
  bool isTimeUp = false;
  int totalmark = 0;
  int skipped = 0;
  int wrongAnswers = 0;
  Options? selectedOption;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (questionTime > 0) {
          questionTime--;
        } else {
          timer.cancel();
          isTimeUp = true;
        }
      });
    });
  }

  String formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  commonHeading('Question'),
                  const Spacer(),
                  questionTime == 0
                    ? const SizedBox()
                    : commonSubHeading(formatTime(questionTime)
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: commonSubHeading('${widget.quesions[selectedQuestion].quizId}) ${widget.quesions[selectedQuestion].question}'),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: height * 0.65,
                child: ListView.builder(
                  itemCount: widget.quesions[selectedQuestion].options.length,
                  itemBuilder: (context, index) {
                    Options option = widget.quesions[selectedQuestion].options[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadioListTile<Options>(
                        value: option,
                        tileColor: selectedOption == option
                          ? Colors.yellow
                          : Colors.transparent,
                        selectedTileColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: const BorderSide(color: Colors.black)
                        ),
                        groupValue: selectedOption,
                        onChanged: (Options? value) {
                          // print('Questions: $selectedQuestion');
                          // print('Questions: ${widget.quesions.length}');
                          setState(() {
                            selectedOption = value!;
                            selectedTileColor = Colors.yellow;
                            if (selectedOption!.option == widget.quesions[selectedQuestion].correctAnswer) {
                              totalmark++;
                              // print('Skipped: $skipped');
                              // print('correct: $totalmark');
                              // print('wrong: $wrongAnswers');
                            } else if (selectedOption!.option != widget.quesions[selectedQuestion].correctAnswer) {
                              if (totalmark >= 0) {
                                wrongAnswers++;
                                // print('Skipped: $skipped');
                                // print('correct: $totalmark');
                                // print('wrong: $wrongAnswers');
                              }
                            } else {
                              totalmark == 0;
                            }
                          });
                        },
                        title: Text(option.option),
                      ),
                    );
                  },
                )
              ),
              // const Spacer(),
              selectedQuestion >= 0
                ? selectedQuestion == widget.quesions.length - 1
                  ? Row(
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: button(
                            boxColor: Colors.transparent,
                            textColor: Colors.black,
                            name: 'Previous',
                            onPressed: () {
                              setState(() {
                                if (selectedQuestion > 0) {
                                  selectedQuestion--;
                                } else {
                                  widget.quesions.clear();
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: width * 0.4,
                          child: button(
                            name: 'View result',
                            onPressed: () {
                              setState(() {
                                // if (widget.quesions.length >
                                //     selectedQuestion + 1) {
                                //   selectedQuestion++;
                                selectedOption =
                                    null; // Clear the selected option
                                // }
                                questionTime = 150;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizResultPage(
                                      totalAnswer: widget.quesions.length,
                                      total: totalmark,
                                      failed: wrongAnswers,
                                      skipped: skipped,
                                    ),
                                  )).then((value) {
                                setState(() {
                                  totalmark = 0;
                                  wrongAnswers = 0;
                                  skipped = 0;
                                  questionTime = 150;
                                });
                              });
                              setState(() {
                                selectedOption =
                                    null; // Clear the selected option
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          child: button(
                            name: 'Previous',
                            onPressed: () {
                              setState(() {
                                if (selectedQuestion > 0) {
                                  selectedQuestion--;
                                }
                              });
                            },
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: width * 0.4,
                          child: button(
                            name: 'Next',
                            onPressed: () {
                              setState(() {
                                if (widget.quesions.length > selectedQuestion + 1) {
                                  selectedQuestion++;
                                  print('Skipped: $skipped');
                                  print('correct: $totalmark');
                                  print('wrong: $wrongAnswers');
                                }
                                questionTime = 150;
                              });
                            },
                          ),
                        ),
                      ],
                    )
              
                : button(
                    name: 'Next',
                    onPressed: () {
                      setState(() {
                        if (widget.quesions.length > selectedQuestion + 1) {
                          selectedQuestion++;
                        }
                        questionTime = 150;
                        print('Skipped: $skipped');
                        print('correct: $totalmark');
                        print('wrong: $wrongAnswers');
                      });
                    },
                  )
            ],
          ),
        ),
      ),
    );
  }
}
