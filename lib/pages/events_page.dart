import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_quiz_page.dart';
import 'all_quizzes_page.dart';
import '../utils/quiz.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        bool isAdmin = snapshot.data!['isAdmin'] ?? false;

        if (!isAdmin) {
          return AllQuizzesPage(isAdmin: false);
        }

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateQuizPage()),
                      );
                    },
                    child: Text("Создать новый квест"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AllQuizzesPage(isAdmin: isAdmin)),
                      );
                    },
                    child: Text("Посмотреть все квесты"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
