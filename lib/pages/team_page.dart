import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/pages/choose_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/my_teams.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final teamNameController = TextEditingController();
  final List<String> teamMemberEmails = [];

  bool _isCaptain =
      false; // Переменная для хранения информации о том, является ли пользователь капитаном

  @override
  void initState() {
    super.initState();
    // Проверяем, является ли пользователь капитаном при загрузке страницы
    checkIsCaptain();
  }

  // Функция для проверки, является ли пользователь капитаном какой-либо команды
  void checkIsCaptain() async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('captain', isEqualTo: user!.uid)
        .get();
    // Если пользователь капитан какой-либо команды, устанавливаем _isCaptain в true
    setState(() {
      _isCaptain = querySnapshot.docs.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Icon(
                  Icons.group,
                  size: 80,
                ),
                Text(
                  "Создай свою команду!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomInputTextField(
                  controller: teamNameController,
                  hintText: 'Название команды',
                  obscureText: false,
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Если пользователь капитан какой-либо команды, показываем все команды
                    if (_isCaptain) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyTeam(),
                        ),
                      );
                    } else {
                      // Если поле название команды не пустое, переходим на страницу выбора пользователей
                      if (teamNameController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseUsers(
                              teamName: teamNameController,
                            ),
                          ),
                        );
                      } else {
                        // Если поле пустое, можно показать пользователю сообщение или ничего не делать
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Пустое название команды'),
                              content:
                                  Text('Пожалуйста, введите название команды.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text("Далее"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyTeam(),
                      ),
                    );
                  },
                  child: Text("Посмотреть мои команды"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
