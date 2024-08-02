import 'question.dart';
import 'quiz_result.dart';

class Quiz {
  String title;
  List<Question> questions;
  List<QuizResult> leaderboard;

  Quiz(
      {required this.title,
      required this.questions,
      this.leaderboard = const []});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'leaderboard': leaderboard.map((result) => result.toMap()).toList(),
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      title: map['title'] ?? '',
      questions: List<Question>.from(
          map['questions']?.map((q) => Question.fromMap(q)) ?? []),
      leaderboard: List<QuizResult>.from(
          map['leaderboard']?.map((result) => QuizResult.fromMap(result)) ??
              []),
    );
  }

  void addResult(QuizResult result) {
    leaderboard.add(result);
    leaderboard.sort((a, b) => b.score.compareTo(a.score));
  }
}
