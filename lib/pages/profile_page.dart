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
                    MaterialPageRoute(builder: (context) => ChangeAvatarPage()),
                  );
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/default_avatar.png'),
                ),
              ),
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
                child: Text('О программе'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
