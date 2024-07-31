import 'package:flutter/material.dart';

class ChooseQuestPage extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final Function(String) onQuestSelected;

  ChooseQuestPage({required this.questions, required this.onQuestSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите квест'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final quest = questions[index];
          return ListTile(
            title: Text(quest['title'] as String),
            onTap: () {
              onQuestSelected(quest['title'] as String);
            },
          );
        },
      ),
    );
  }
}
