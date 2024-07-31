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
      title: map['title'],
      questions: (map['questions'] as List)
          .map((q) => Question(
                questionText: q['questionText'],
                options: List<String>.from(q['options']),
                correctAnswers: List<int>.from(
                    q['correctAnswers'] ?? []), // Handle null case
              ))
          .toList(),
    );
  }
}
