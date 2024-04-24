import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Данное приложение разработано для проведения оффлайн мероприятий среди команд. Оно отлично подойдет для оффлайн квестов на предприятиях или на природе/в городских джунглях.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Разработчик: Gleb Timoshenko',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Telegram: @glebushnik',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'GitHub: https://github.com/glebushnik',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
