import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/quiz.dart';
import 'quiz_detail_page.dart';
import 'quiz_taking_page.dart';

class AllQuizzesPage extends StatelessWidget {
  final bool isAdmin;

  AllQuizzesPage({required this.isAdmin});

  void _deleteQuiz(String quizId) {
    FirebaseFirestore.instance.collection('quizzes').doc(quizId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAdmin ? AppBar(title: Text("Квесты")) : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Пока нет доступных квестов."));
          }

          // Group quizzes by enterprise
          Map<String, List<DocumentSnapshot>> groupedQuizzes = {};
          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            String enterprise = data['enterprise'] ?? 'Другие предприятия';
            if (!groupedQuizzes.containsKey(enterprise)) {
              groupedQuizzes[enterprise] = [];
            }
            groupedQuizzes[enterprise]!.add(doc);
          }

          return ListView.builder(
            itemCount: groupedQuizzes.length,
            itemBuilder: (context, index) {
              String enterprise = groupedQuizzes.keys.elementAt(index);
              List<DocumentSnapshot> quizzes = groupedQuizzes[enterprise]!;

              return ExpansionTile(
                title: Text(enterprise),
                children: quizzes.map((doc) {
                  var quiz = Quiz.fromMap(doc.data() as Map<String, dynamic>);
                  var quizId = doc.id;

                  return ListTile(
                    title: Text(quiz.title),
                    subtitle: Text("${quiz.questions.length} вопрос(ов)"),
                    trailing: isAdmin
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteQuiz(quizId);
                            },
                          )
                        : null,
                    onTap: () {
                      if (isAdmin) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetailPage(quiz: quiz, quizId: quizId),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizTakingPage(quiz: quiz, quizId: quizId),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
