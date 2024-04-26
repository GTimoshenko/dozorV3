import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/event_bubble.dart';
import 'package:flutter_application_1/pages/my_event_page.dart'; // Import the MyEventPage class

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои квесты'),
      ),
      body: currentUserId != null
          ? StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('events')
                  .where('createdBy', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final events = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final eventId = event.id;
                    final createdBy = event['createdBy'];
                    final eventName = event['eventName'];
                    final members = List<String>.from(event['members']);
                    final isActive = event['isActive'];
                    final start = (event['start'] as Timestamp).toDate();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyEventPage(eventId: eventId),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EventBubble(
                          eventId: eventId,
                          createdBy: createdBy,
                          eventName: eventName,
                          members: members,
                          isActive: isActive,
                          start: start,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Text('Loading...'),
            ),
    );
  }
}
