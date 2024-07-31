import 'package:flutter/material.dart';
import '../utils/quiz.dart';

class QuizDetailPage extends StatelessWidget {
  final Quiz quiz;

  QuizDetailPage({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: quiz.questions.length,
          itemBuilder: (context, index) {
            var question = quiz.questions[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Q${index + 1}: ${question.questionText}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...question.options.asMap().entries.map((entry) {
                      int optionIndex = entry.key;
                      String option = entry.value;
                      return Text(
                          "${optionIndex + 1}. $option ${question.correctAnswers.contains(optionIndex) ? '✅' : '❌'}");
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
