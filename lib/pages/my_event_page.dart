import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/event_bubble.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyEventPage extends StatefulWidget {
  final String eventId;

  const MyEventPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _MyEventPageState createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, bool> shownToasts =
      {}; // Карта для отслеживания показанных уведомлений

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О мероприятии'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.eventId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Данные о мероприятии не найдены'));
          }

          Map<String, dynamic> eventData =
              snapshot.data!.data() as Map<String, dynamic>;
          DateTime start = (eventData['start'] as Timestamp).toDate();
          List<String> members = (eventData['members'] as List).cast<String>();

          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EventBubble(
                        eventId: widget.eventId,
                        createdBy: eventData['createdBy'],
                        eventName: eventData['eventName'],
                        members: members,
                        isActive: eventData['isActive'],
                        start: start,
                      ),
                    ),
                    CustomInputTextField(
                      controller: _messageController,
                      hintText: "Введите объявление",
                      obscureText: false,
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Действия при нажатии на кнопку
                          String message = _messageController.text;
                          await Future.forEach(members, (member) async {
                            if (!shownToasts.containsKey(member) ||
                                !shownToasts[member]!) {
                              await Fluttertoast.showToast(
                                msg: '$message',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                              );

// Wrap the toast message in a GestureDetector to handle tap events
                              GestureDetector(
                                onTap: () {
                                  // Define the action to take when the toast message is tapped
                                  shownToasts[member] = true;
                                  Fluttertoast.cancel();
                                },
                                child: SizedBox
                                    .shrink(), // Use an empty SizedBox to make the GestureDetector cover the entire toast message area
                              );

                              shownToasts[member] =
                                  false; // Отмечаем, что уведомление было показано
                            }
                          });
                          _messageController
                              .clear(); // Очищаем текстовое поле после отправки
                        },
                        child: Text('Сделать объявление'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
