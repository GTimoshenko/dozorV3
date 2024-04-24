import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Упс, еще нет мероприятий...',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
