import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/quiz.dart';
import 'quiz_detail_page.dart';

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
                onTap: isAdmin
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizDetailPage(quiz: quiz),
                          ),
                        );
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
