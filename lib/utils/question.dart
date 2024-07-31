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
}
