import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/input_text_field.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final eventNamecontroller = TextEditingController();
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
                  "Создай свое мероприятие!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomInputTextField(
                  controller: eventNamecontroller,
                  hintText: 'Название мероприятия',
                  obscureText: false,
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Далее"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Посмотреть мои мероприятия."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
