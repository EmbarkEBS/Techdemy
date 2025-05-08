class QuizQuestions {
  final int quizId;
  final int chapterId;
  final String quizType;
  final String question;
  final List<Options> options;
  // final String optionA;
  // final String optionB;
  // final String optionC;
  // final String optionD;
  final String correctAnswer;
  QuizQuestions({
    required this.quizId,
    required this.chapterId,
    required this.quizType,
    required this.question,
    required this.options,
    // required this.optionA,
    // required this.optionB,
    // required this.optionC,
    // required this.optionD,
    required this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'quizId': quizId});
    result.addAll({'chapterId': chapterId});
    result.addAll({'question': question});
    result.addAll({'options': options});
    result.addAll({'correctAnswer': correctAnswer});

    return result;
  }

  factory QuizQuestions.fromJson(Map<String, dynamic> json) {
    List<Options> optionList = [
      Options(option: json['option_a'] ?? ''),
      Options(option: json['option_b'] ?? ''),
      Options(option: json['option_c'] ?? ''),
      Options(option: json['option_d'] ?? ''),
    ];
    return QuizQuestions(
      quizId: json['quiz_id']?.toInt() ?? 0,
      chapterId: json['chapter_id']?.toInt() ?? 0,
      question: json['question'] ?? '',
      options: optionList,
      correctAnswer: json['correct_answer'] ?? '',
      quizType: json['quiz_type'] ?? '',
    );
  }

  // String toJson() => json.encode(toMap());

  // factory QuizQuestions.fromJson(String source) =>
  //     QuizQuestions.fromMap(json.decode(source));
}

class Options {
  final String option;
  Options({required this.option,});

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'option': option});

    return result;
  }

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      option: json['option'] ?? '',
    );
  }
}
