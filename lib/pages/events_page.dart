import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/choose_teams.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final eventNamecontroller = TextEditingController();

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
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 155, 132, 197),
                                                ),
                                              ),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(Size(
                                                    200,
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
                        onPressed: () {},
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
            body: Center(
              child: Text(
                "Упс, здесь скоро будут твои квесты",
              ),
            ),
          );
        }

        // Если пользователь не является администратором, вернуть пустой контейнер
      },
    );
  }
}
