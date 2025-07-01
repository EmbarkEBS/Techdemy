class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  /// Factory constructor to create from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json["question_id"] ?? 0,
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
    );
  }

  /// Optional: toJson if you want to convert it back
  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}

