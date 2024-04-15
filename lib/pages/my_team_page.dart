import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/team_bubble.dart';
import 'package:flutter_application_1/pages/my_teams.dart';
import 'package:flutter_application_1/pages/team_chat_page.dart';

class MyTeamPage extends StatelessWidget {
  final String teamId;

  const MyTeamPage({Key? key, required this.teamId}) : super(key: key);

  Future<List<String>> _getIdsFromEmails(List<String> emailAddresses) async {
    List<String> userIds = [];

    for (String email in emailAddresses) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic>? userData =
            snapshot.docs[0].data() as Map<String, dynamic>;
        String? userId = userData['uid'];
        if (userId != null) {
          userIds.add(userId);
        }
      }
    }

    return userIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о команде'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .doc(teamId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          var teamData = snapshot.data?.data() as Map<String, dynamic>?;

          if (teamData == null) {
            return Center(child: Text('Данные о команде не найдены'));
          }

          var teamName = teamData['name'] ?? 'Название не указано';
          var captainId = teamData['createdBy'] ?? 'Капитан не указан';
          var members = List<String>.from(teamData['members']);

          return Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: TeamBubble(
                      teamName: teamName,
                      teamId: teamId,
                      captainId: captainId,
                      members: members,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300, // Растягиваем кнопку на всю доступную ширину
                child: ElevatedButton(
                  onPressed: () {
                    // Действия при нажатии на кнопку "Добавить участника"
                  },
                  child: Text('Добавить участника'),
                ),
              ),
              FutureBuilder(
                future: _getIdsFromEmails(members),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  }
                  print(snapshot.data ?? []);
                  print(members);
                  return SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamChatPage(
                              receiverUserIds: snapshot.data ?? [],
                              receiverUserEmails: members,
                            ),
                          ),
                        );
                      },
                      child: Text('Чат команды'),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 300, // Растягиваем кнопку на всю доступную ширину
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('teams')
                          .doc(teamId)
                          .delete();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyTeam(
                            shouldReload: true,
                          ),
                        ),
                      );

                      // Возвращаемся на предыдущий экран после удаления
                    } catch (error) {
                      print('Ошибка при удалении команды: $error');
                    }
                  },
                  child: Text('Удалить команду'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
