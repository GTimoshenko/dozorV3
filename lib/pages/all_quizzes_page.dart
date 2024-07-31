import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/quiz.dart';
import 'events_page.dart';

class AllQuizzesPage extends StatelessWidget {
  final bool isAdmin;

  AllQuizzesPage({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Все квесты")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Пока нет доступных квестов."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var quiz = Quiz.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return ListTile(
                title: Text(quiz.title),
                subtitle: Text("${quiz.questions.length} вопрос(ов)"),
                onTap: () {
                  if (isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizDetailPage(quiz: quiz),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "У вас недостаточно прав, чтобы просматривать этот раздел.")));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
