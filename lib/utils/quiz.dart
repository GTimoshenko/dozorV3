class Quiz {
  String title;
  List<Question> questions;

  Quiz({required this.title, required this.questions});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }
}

class Question {
  String questionText;
  List<String> options;

  Question({required this.questionText, required this.options});

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
    };
  }
}
