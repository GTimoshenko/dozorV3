import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/event_bubble.dart';

class MyEventPage extends StatelessWidget {
  final String eventId;

  const MyEventPage({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О мероприятии'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
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
                        eventId: eventId,
                        createdBy: eventData['createdBy'],
                        eventName: eventData['eventName'],
                        members: members,
                        isActive: eventData['isActive'],
                        start: start,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          // Действия при нажатии на кнопку
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
