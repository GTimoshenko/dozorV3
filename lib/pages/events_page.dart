import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/event_bubble.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/choose_teams.dart';
import 'package:flutter_application_1/pages/my_events.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final eventNamecontroller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  final List<Map<String, Object>> _questions = [
    {
      'question': 'Какого цвета небо?',
      'answers': [
        {'text': 'Синий', 'score': 1},
        {'text': 'Зелёный', 'score': 0},
        {'text': 'Красный', 'score': 0},
        {'text': 'Чёрный', 'score': 0},
      ],
    },
    {
      'question': 'Сколько ног у паука?',
      'answers': [
        {'text': '6', 'score': 0},
        {'text': '8', 'score': 1},
        {'text': '10', 'score': 0},
        {'text': '12', 'score': 0},
      ],
    },
    // Добавьте остальные вопросы в аналогичном формате
    {
      'question': 'Какой сейчас год?',
      'answers': [
        {'text': '2022', 'score': 0},
        {'text': '2023', 'score': 1},
        {'text': '2024', 'score': 0},
        {'text': '2025', 'score': 0},
      ],
    },
    {
      'question': 'Как зовут главного героя романа "Преступление и наказание"?',
      'answers': [
        {'text': 'Родион', 'score': 1},
        {'text': 'Роман', 'score': 0},
        {'text': 'Алексей', 'score': 0},
        {'text': 'Иван', 'score': 0},
      ],
    },
    {
      'question': 'Столица Франции?',
      'answers': [
        {'text': 'Лондон', 'score': 0},
        {'text': 'Париж', 'score': 1},
        {'text': 'Берлин', 'score': 0},
        {'text': 'Мадрид', 'score': 0},
      ],
    },
  ];

  int _questionIndex = 0;
  int _totalScore = 0;

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: _hideKeyboard, // Hide keyboard when tapping anywhere on the screen
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Отображение загрузки, пока данные не загрузятся
          }

          bool isAdmin = snapshot.data!['isAdmin'] ?? false;

          if (isAdmin) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Icon(
                          Icons.device_unknown,
                          size: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Создайте свой квест!",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomInputTextField(
                          controller: eventNamecontroller,
                          hintText: 'Название квеста',
                          obscureText: false,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (eventNamecontroller.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseTeams(
                                    eventName: eventNamecontroller,
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Пустое название квеста!'),
                                    content: Text(
                                      'Чтобы создать квест, введите его название.',
                                    ),
                                    actions: <Widget>[
                                      ButtonBar(
                                        alignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Закрываем диалоговое окно
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color.fromARGB(
                                                    255, 155, 132, 197),
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 155, 132, 197),
                                                  ),
                                                ),
                                              ),
                                              minimumSize: MaterialStateProperty
                                                  .all(Size(200,
                                                      48)), // Задаем фиксированный размер кнопки
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text("Далее"),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                200, 48)), // Задаем фиксированный размер кнопки
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyEvents(),
                              ),
                            );
                          },
                          child: Text("Посмотреть мои квесты"),
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                                200, 48)), // Задаем фиксированный размер кнопки
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Опрос'),
              ),
              body: _questionIndex < _questions.length
                  ? Quiz(
                      questions: _questions,
                      questionIndex: _questionIndex,
                      answerQuestion: _answerQuestion,
                    )
                  : Result(_totalScore, _resetQuiz),
            );
          }

          // Если пользователь не является администратором, вернуть пустой контейнер
        },
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int questionIndex;
  final Function answerQuestion;

  Quiz({
    required this.questions,
    required this.questionIndex,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questionIndex]['question'] as String,
        ),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
            () => answerQuestion(answer['score'] as int),
            answer['text'] as String,
          );
        }).toList(),
      ],
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final Function selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: Text(answerText),
        onPressed: () => selectHandler(),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    return 'Ваш результат: $resultScore';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            child: Text('Пройти снова'),
            onPressed: () => resetHandler(),
          ),
        ],
      ),
    );
  }
}
