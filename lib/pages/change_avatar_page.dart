import 'package:flutter/material.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление фото профиля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change your avatar here',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
