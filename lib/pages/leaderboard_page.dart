import 'package:flutter/material.dart';
import '../utils/quiz.dart';

class LeaderboardPage extends StatelessWidget {
  final Quiz quiz;

  LeaderboardPage({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Таблица лидеров")),
      body: ListView.builder(
        itemCount: quiz.leaderboard.length,
        itemBuilder: (context, index) {
          var result = quiz.leaderboard[index];
          return ListTile(
            title: Text(result.playerName),
            trailing:
                Text("Результат: ${result.score}/${quiz.questions.length}"),
          );
        },
      ),
    );
  }
}
