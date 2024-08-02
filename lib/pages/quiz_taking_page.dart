import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/quiz.dart';
import '../utils/quiz_result.dart';
import 'leaderboard_page.dart';

class QuizTakingPage extends StatefulWidget {
  final Quiz quiz;
  final String quizId;

  QuizTakingPage({required this.quiz, required this.quizId});

  @override
  _QuizTakingPageState createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  Map<int, List<int>> _selectedAnswers = {};

  void _toggleAnswer(int questionIndex, int optionIndex) {
    setState(() {
      if (_selectedAnswers[questionIndex]?.contains(optionIndex) ?? false) {
        _selectedAnswers[questionIndex]?.remove(optionIndex);
      } else {
        _selectedAnswers[questionIndex] =
            (_selectedAnswers[questionIndex] ?? [])..add(optionIndex);
      }
    });
  }

  void _submitQuiz() async {
    int correctAnswers = 0;

    widget.quiz.questions.asMap().forEach((index, question) {
      if (_selectedAnswers[index] != null &&
          _selectedAnswers[index]!
              .every((answer) => question.correctAnswers.contains(answer)) &&
          _selectedAnswers[index]!.length == question.correctAnswers.length) {
        correctAnswers++;
      }
    });

    User? user = FirebaseAuth.instance.currentUser;
    String playerName = user?.email ?? "Unknown Player";

    // Save the result in the leaderboard
    widget.quiz.addResult(QuizResult(
        playerName: playerName,
        score: correctAnswers)); // Use the current user's email

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(widget.quizId)
        .update(widget.quiz.toMap());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Результаты"),
        content: Text(
            "Вы ответили правильно на $correctAnswers из ${widget.quiz.questions.length} вопросов."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LeaderboardPage(quiz: widget.quiz),
                ),
              );
            },
            child: Text("ОК"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.quiz.questions.length,
        onPageChanged: (index) {
          setState(() {
            _currentQuestionIndex = index;
          });
        },
        itemBuilder: (context, index) {
          var question = widget.quiz.questions[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Вопрос ${index + 1}/${widget.quiz.questions.length}: ${question.questionText}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...question.options.asMap().entries.map((entry) {
                  int optionIndex = entry.key;
                  String option = entry.value;
                  return CheckboxListTile(
                    title: Text(option),
                    value:
                        _selectedAnswers[index]?.contains(optionIndex) ?? false,
                    onChanged: (_) => _toggleAnswer(index, optionIndex),
                  );
                }).toList(),
                Center(
                  child: ElevatedButton(
                    onPressed: index == widget.quiz.questions.length - 1
                        ? _submitQuiz
                        : () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: Text(index == widget.quiz.questions.length - 1
                        ? "Завершить квест"
                        : "Следующий вопрос"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
