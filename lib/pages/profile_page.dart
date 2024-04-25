import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/change_avatar_page.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'about_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    String? userId = user?.uid;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Центрирование элементов по вертикали
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Обернули аватар в InkWell
              InkWell(
                  onTap: () {
                    // Переход на страницу изменения аватара при нажатии на аватарку
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeAvatarPage()),
                    );
                  },
                  child: Icon(Icons.account_circle_outlined, size: 100)),
              SizedBox(height: 20),
              Text(
                'Электронная почта:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                email ?? 'Нет данных',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Переход на страницу "О программе" при нажатии на кнопку
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
                child: Text('О приложении'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(200, 48)), // Задаем фиксированный размер кнопки
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Обновляем поле isAdmin в Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({'isAdmin': true});

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Поздравляем!'),
                            content: Text(
                                'Теперь вы стали организатором и можете создавать свои мероприятия.'),
                            actions: <Widget>[
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 155, 132, 197)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 155, 132, 197)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      print('Нет текущего пользователя.');
                    }
                  } catch (error) {
                    print('Ошибка при обновлении поля isAdmin: $error');
                  }
                },
                child: Text('Стать организатором'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(200, 48)), // Задаем фиксированный размер кнопки
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Получение текущего пользователя
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // 1. Удаление пользователя из Firebase Authentication
                      await user.delete();

                      // 2. Удаление информации о пользователе из Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .delete();

                      print(
                          'Пользователь с id $userId удален без возможности дальнейшей авторизации и восстановления.');
                    } else {
                      print('Нет текущего пользователя.');
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          onTap: () {},
                        ),
                      ),
                    );
                  } catch (error) {
                    print('Ошибка при удалении пользователя: $error');
                  }
                },
                child: Text('Удалить аккаунт'),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(200, 48)), // Задаем фиксированный размер кнопки
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
