import 'question.dart';

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

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      title: map['title'] ?? '',
      questions: List<Question>.from(
          map['questions']?.map((q) => Question.fromMap(q)) ?? []),
    );
  }
}
