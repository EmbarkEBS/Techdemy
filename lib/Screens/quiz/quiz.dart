import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Helpers/encrypter.dart';
import 'package:tech/Models/quiz_model.dart';
import 'package:http/http.dart' as http;
import 'package:tech/controllers/course_controller.dart';

class QuizScreen extends StatefulWidget {
  final int chapterId;
  final List<QuizQuestion> questions;
  const QuizScreen({super.key, required this.chapterId, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  final Map<int, int?> _selectedAnswers = {}; // question.id -> selectedOptionIndex

  @override
  void initState() {
    super.initState();
    // _startTimer(widget.duration.inSeconds);
  }

  // TODO: Start timer once the API is called in the future builder
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

  void _showResult({required bool autoSubmitted}) {
    // final isCorrect = _selectedIndex == widget.question.correctAnswerIndex;
    final message = autoSubmitted
        ? "Time's up!"
        : "Well done";

    !autoSubmitted
    ? _submitQuestions
    : showDialog(
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

  Future<void> _submitQuestions() async {
    final formattedAnswers = _selectedAnswers.entries.map((entry) => {
      'question_id': entry.key,
      'selected_option_index': entry.value,
    }).toList();

    const url = 'https://techdemy.in/connect/api/submitquiz';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"data": encryption(json.encode(formattedAnswers))}),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=utf-8'
        },
      );

      if (response.statusCode == 200) {
        String decryptedData = decryption(response.body);
        Map<String, dynamic> result = json.decode(
          decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
        );

        String message = result['message'] ?? 'Quiz Submitted Successfully';

        // Show result popup at center
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("Time Over"),
              content: Text(message),
            ),
          );

          // Wait 3 seconds and auto-close
          await Future.delayed(const Duration(seconds: 3));

          if (context.mounted) {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back
          }
        }
      } else {
        _showError("Submission failed. Please try again.");
      }
    } catch (e) {
      _showError("An error occurred: $e");
    }
  }

  void _showError(String message) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final questions = widget.question;
    final controller = Get.find<CourseController>();
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
      body: ListView.separated(
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
          backgroundColor: Colors.black87,
          
          onPressed: _selectedAnswers.isNotEmpty ? _submit : null,
          child: const Text(
            "Submit",
            style: TextStyle(
              fontSize: 15,
              color: Colors.yellow,
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
