import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/question.dart';
import '../utils/quiz.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _enterpriseController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final PageController _pageController = PageController();
  final List<Question> _questions = [
    Question(questionText: '', options: ['', '', '', ''], correctAnswers: [])
  ];
  int _currentQuestionIndex = 0;
  bool _showQuizForm = false;

  void _setQuestionText(String text) {
    setState(() {
      _questions[_currentQuestionIndex].questionText = text;
    });
  }

  void _setOptionText(int index, String text) {
    setState(() {
      _questions[_currentQuestionIndex].options[index] = text;
    });
  }

  void _toggleCorrectAnswer(int index) {
    setState(() {
      if (_questions[_currentQuestionIndex].correctAnswers.contains(index)) {
        _questions[_currentQuestionIndex].correctAnswers.remove(index);
      } else {
        _questions[_currentQuestionIndex].correctAnswers.add(index);
      }
    });
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add(Question(
          questionText: '', options: ['', '', '', ''], correctAnswers: []));
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _createQuiz() async {
    String enterprise = _enterpriseController.text.trim();
    String title = _titleController.text.trim();
    if (enterprise.isEmpty ||
        title.isEmpty ||
        _questions.any((q) =>
            q.questionText.isEmpty ||
            q.options.any((opt) => opt.isEmpty) ||
            q.correctAnswers.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Пожалуйста, заполните все поля и выберите, как минимум, один правильный ответ.")));
      return;
    }

    await _firestore.collection('quizzes').add({
      'enterprise': enterprise,
      ...Quiz(title: title, questions: _questions).toMap(),
    });
    _enterpriseController.clear();
    _titleController.clear();
    setState(() {
      _questions.clear();
      _questions.add(Question(
          questionText: '', options: ['', '', '', ''], correctAnswers: []));
      _currentQuestionIndex = 0;
      _showQuizForm = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Квест успешно создан!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Создать новый квест")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _showQuizForm ? _buildQuizForm() : _buildEnterpriseForm(),
        ),
      ),
    );
  }

  Widget _buildEnterpriseForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _enterpriseController,
          decoration: InputDecoration(labelText: "Предприятие"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_enterpriseController.text.trim().isNotEmpty) {
              setState(() {
                _showQuizForm = true;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Пожалуйста, введите название предприятия.")),
              );
            }
          },
          child: Text("Перейти к заполнению квеста"),
        ),
      ],
    );
  }

  Widget _buildQuizForm() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: "Название квеста"),
        ),
        SizedBox(height: 10),
        Expanded(
          child: PageView.builder(
            itemCount: _questions.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentQuestionIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onChanged: _setQuestionText,
                          decoration:
                              InputDecoration(labelText: "Вопрос ${index + 1}"),
                        ),
                        ..._questions[index]
                            .options
                            .asMap()
                            .entries
                            .map((entry) {
                          int optionIndex = entry.key;
                          String option = entry.value;
                          return CheckboxListTile(
                            title: TextField(
                              onChanged: (text) =>
                                  _setOptionText(optionIndex, text),
                              decoration: InputDecoration(
                                  labelText: "Вариант ${optionIndex + 1}"),
                            ),
                            value: _questions[index]
                                .correctAnswers
                                .contains(optionIndex),
                            onChanged: (_) => _toggleCorrectAnswer(optionIndex),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentQuestionIndex > 0
                  ? () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              child: Text("Предыдущий"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentQuestionIndex < _questions.length - 1) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _addNewQuestion();
                }
              },
              child: Text("Следующий"),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _questions.any((q) =>
                  q.questionText.isNotEmpty &&
                  q.options.every((opt) => opt.isNotEmpty) &&
                  q.correctAnswers.isNotEmpty)
              ? _createQuiz
              : null,
          child: Text("Создать квест"),
        ),
      ],
    );
  }
}
