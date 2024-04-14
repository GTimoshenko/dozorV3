import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/pages/choose_users.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final teamNameController = TextEditingController();
  final List<String> teamMemberEmails = [];
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
                    // Проверяем, содержит ли поле название команды какой-либо текст
                    if (teamNameController.text.isNotEmpty) {
                      // Если содержит, переходим на следующую страницу
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChooseUsers(teamName: teamNameController),
                        ),
                      );
                    } else {
                      // Если поле пустое, можно показать пользователю сообщение или ничего не делать
                      // Например, показать всплывающее окно с предупреждением:
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
                  },
                  child: Text("Далее"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
