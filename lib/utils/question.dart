class Question {
  String questionText;
  List<String> options;
  List<int> correctAnswers;

  Question(
      {required this.questionText,
      required this.options,
      required this.correctAnswers});

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswers': correctAnswers,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options']),
      correctAnswers: List<int>.from(map['correctAnswers']),
    );
  }
}
