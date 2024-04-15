import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/team_bubble.dart';
import 'package:flutter_application_1/pages/messenger_page.dart';
import 'package:flutter_application_1/pages/my_team_page.dart';
import 'package:flutter_application_1/pages/team_page.dart'; // Импортируем нужную страницу

class MyTeam extends StatefulWidget {
  final bool shouldReload; // Добавляем параметр shouldReload

  const MyTeam({Key? key, required this.shouldReload}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  late String currentUserId;
  bool _isRedirecting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRedirecting) {
      getCurrentUserId();
    }
  }

  void getCurrentUserId() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserId = currentUser.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои команды'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: widget.shouldReload ? _getUserTeams() : Future.value([]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          }

          var userTeams = snapshot.data ?? [];

          if (userTeams.isEmpty && !_isRedirecting) {
            _isRedirecting = true;
            _redirectToHomePage();
            return Center(
              child: Text('У вас пока нет команд'),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: userTeams.length,
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemBuilder: (context, index) {
              var teamData = userTeams[index].data() as Map<String, dynamic>;
              var teamName = teamData['name'] ?? 'Название не указано';
              var captainId = teamData['createdBy'] ?? 'Капитан не указан';
              var members = List<String>.from(teamData['members']);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyTeamPage(teamId: userTeams[index].id),
                    ),
                  );
                },
                child: TeamBubble(
                  teamName: teamName,
                  teamId: userTeams[index].id, // Здесь используйте doc.id
                  captainId: captainId,
                  members: members,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getUserTeams() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    final currentUserEmail = currentUser.email;

    final memberTeamsQuery = await FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: currentUserEmail)
        .get();

    final teams = [...memberTeamsQuery.docs];

    // Используйте Set для удаления дубликатов команд
    final uniqueTeams = teams.toSet().toList();

    return uniqueTeams;
  }

  void _redirectToHomePage() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }
}
