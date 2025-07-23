import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int total;
  final int correct;
  const QuizResultScreen({super.key, required this.total, required this.correct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.done, size: 124, color: Colors.green,),
          Text(
            "$correct in $total are correct answers", 
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 48, 
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}