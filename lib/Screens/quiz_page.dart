import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:tech/controllers/course_controller.dart';

class QuizScreen extends StatefulWidget {
  final int chapterId;
  final String? enrollId;
  final int timer;
  final int courseId;
  final List<QuizQuestion> questions;
  const QuizScreen({
    super.key, 
    required this.chapterId, 
    required this.questions, 
    required this.timer,
    required this.courseId,
    this.enrollId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isLoading = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  final Map<int, int?> _selectedAnswers = {}; // question.id -> selectedOptionIndex
  final Map<String, int> _correctAnswers = {"count": 0};

  @override
  void initState() {
    super.initState();
    _startTimer(widget.timer);
  }

  void _startTimer(int seconds) {
    _remainingSeconds = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _autoSubmit();
      }
    });
  }

  void _autoSubmit() {
    _showResult(autoSubmitted: true);
  }

  void _submit() {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _showResult(autoSubmitted: false);
  }

  Future<void> _showResult({required bool autoSubmitted}) async {
    // final isCorrect = _selectedIndex == widget.question.correctAnswerIndex;
    final message = autoSubmitted
        ? "Time's up!"
        : "Well done";
    if(!autoSubmitted) {
      await _submitQuestions();
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(autoSubmitted ? "Time Over!" : "Result"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              },
              child: const Text("Back"),
            )
          ],
        ),
      );
    } 
  }

  Future<void> _submitQuestions() async {
    try {
      setState(() {
        _isLoading = true;
      });
      int n = widget.questions.length;
      int correctAnswers = _correctAnswers["count"]!;
      Map<String, dynamic> data = {
        "course_id": widget.courseId,
        "chapter_id": widget.chapterId,
        "no_of_questions": n,
        "correct_answers": correctAnswers,
        "incorrect_answers": n - correctAnswers,
        "no_of_attempts": 1,
        "score": correctAnswers,
        "percentage":  n > 0 ? (correctAnswers / n) * 100 : 0.0
      };
      final controller = Get.find<CourseController>();
      await controller.submitQuiz(data);
      await controller.updateProgress(widget.enrollId ?? "", widget.chapterId.toString());
    } catch (e) {
      debugPrint("Something went wrong on submit ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        actions: [
          TextButton(
            onPressed: (){},
            child: Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                color: Colors.red
              )
            ),
          ),
        ],
      ),
      body: widget.questions.isEmpty
      ? const Center(
          child: Text("No quiz found for this course"),
        )
      : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final q = widget.questions[index];
          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index+1}) ${q.question}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5,),
              ...List.generate(q.options.length, (optionIndex) {
                return RadioListTile<int>(
                  dense: true,
                  title: Text(q.options[optionIndex]),
                  value: optionIndex,  // Always a valid int
                  groupValue: _selectedAnswers[q.id], // Can be null
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswers[q.id] = value!;

                      // Recalculate correct answers
                      int correct = 0;
                      for (var question in widget.questions) {
                          final selected = _selectedAnswers[question.id];
                          if (selected != null && selected + 1 == question.correctAnswerIndex) {
                            correct++;
                          }
                        }
                      _correctAnswers["count"] = correct;
                    });
                  },
                );
              }),
            ],
          );
        }, 
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: double.infinity,
            child: Divider(
              color: Colors.black45,
              thickness: 1,
            ),
          );
        }, 
        itemCount: widget.questions.length
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons:  [
        SizedBox(
        width: double.infinity,
        child: FloatingActionButton(
          backgroundColor: widget.questions.length == _selectedAnswers.length ? Colors.black87 : Colors.black38,
          
          onPressed: () {
            if(widget.questions.length == _selectedAnswers.length && _selectedAnswers.isNotEmpty) {
              _submit();
            } 
            // _selectedAnswers.isNotEmpty ? _submit : null;
          },
          child: _isLoading 
          ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            )
          : Text(
            "Submit",
            style: TextStyle(
              fontSize: 15,
              color: widget.questions.length == _selectedAnswers.length ?Colors.yellow : Colors.yellow.shade200,
              fontWeight: FontWeight.bold
            )
          ),
        ),
      )
      ],
    );
  }


  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

}
