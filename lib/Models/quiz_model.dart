class QuizQuestion {
  final int id;
  final int chapterId;
  final String question;
  final String quizType;
  final List<String> options;
  final int correctAnswerIndex;
  QuizQuestion({
    required this.id,
    required this.chapterId,
    required this.question,
    required this.quizType,
    required this.options,
    required this.correctAnswerIndex,
  });

  /// Factory constructor to create from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<String> options = List.generate(4, (index) => json["option_${String.fromCharCode(97 + index)}"],);
    return QuizQuestion(
      id: json["quiz_id"] ?? 0,
      chapterId: int.tryParse(json["chapter_id"]) ?? 0,
      question: (json['question'] ?? "").toString() ,
      quizType: (json['quiz_type'] ?? "").toString(),
      options: options,
      correctAnswerIndex: int.tryParse(json['correct_answer']) ?? 0,
    );
  }

  /// Optional: toJson if you want to convert it back
  Map<String, dynamic> toJson() {
    return {
      'quiz_id' : id,
      'chapter_id': chapterId,
      'question': question,
      'quiz_type': quizType,
      'options': options,
      'correct_answer': correctAnswerIndex,
    };
  }
}

