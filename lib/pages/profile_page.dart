import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/change_avatar_page.dart';
import 'about_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

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
              ),

              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Поздравляем!'),
                        content: Text(
                            'Теперь вы стали организатором и можете создавать свои мероприятия.'),
                        actions: <Widget>[
                          ButtonBar(
                            alignment: MainAxisAlignment
                                .center, // Выравнивание кнопки "OK" по центру
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
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 155, 132,
                                              197)), // Цвет кнопки "OK"
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          18.0), // Задаем скругленные углы
                                      side: BorderSide(
                                          color: const Color.fromARGB(255, 155,
                                              132, 197)), // Добавляем обводку
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
                },
                child: Text('Стать организатором'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
