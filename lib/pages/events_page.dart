import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final PageController _pageController = PageController();
  final List<Question> _questions = [
    Question(questionText: '', options: ['', '', '', ''], correctAnswers: [])
  ];
  int _currentQuestionIndex = 0;

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

  Future<void> _createQuiz() async {
    String title = _titleController.text.trim();
    if (title.isEmpty ||
        _questions.any((q) =>
            q.questionText.isEmpty ||
            q.options.any((opt) => opt.isEmpty) ||
            q.correctAnswers.isEmpty)) {
      // Show a message if the title or any question/option is empty or no correct answers are selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Пожалуйста, заполните все поля и выберите, как минимум, один правильный ответ.")));
      return;
    }

    await _firestore
        .collection('quizzes')
        .add(Quiz(title: title, questions: _questions).toMap());
    _titleController.clear();
    setState(() {
      _questions.clear();
      _questions.add(Question(
          questionText: '', options: ['', '', '', ''], correctAnswers: []));
      _currentQuestionIndex = 0;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Квест успешно создан!")));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        }

        bool isAdmin = snapshot.data!['isAdmin'] ?? false;

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Название квеста."),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                                    decoration: InputDecoration(
                                        labelText: "Вопрос ${index + 1}"),
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
                                            labelText:
                                                "Вариант ${optionIndex + 1}"),
                                      ),
                                      value: _questions[index]
                                          .correctAnswers
                                          .contains(optionIndex),
                                      onChanged: (_) =>
                                          _toggleCorrectAnswer(optionIndex),
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
                        onPressed: _currentQuestionIndex < _questions.length - 1
                            ? () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : _createQuiz, // If it's the last question, create the quiz
                        child: Text("Следующий"),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllQuizzesPage(isAdmin: isAdmin)),
                      );
                    },
                    child: Text("Посмотреть все квесты"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AllQuizzesPage extends StatelessWidget {
  final bool isAdmin;

  AllQuizzesPage({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Все квесты")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Пока нет доступных квестов."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var quiz = Quiz.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return ListTile(
                title: Text(quiz.title),
                subtitle: Text("${quiz.questions.length} вопрос(ов)"),
                onTap: () {
                  if (isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizDetailPage(quiz: quiz),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "У вас недостаточно прав, чтобы просматривать этот раздел.")));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

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
                          "${optionIndex + 1}. $option ${question.correctAnswers.contains(optionIndex) ? '(Правильный)' : ''}");
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
