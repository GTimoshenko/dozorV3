import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/team_bubble.dart';

class MyTeam extends StatefulWidget {
  const MyTeam({Key? key});

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
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
      body: _buildTeamList(),
    );
  }

  Widget _buildTeamList() {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _getUserTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        }

        var userTeams = snapshot.data ?? [];

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: userTeams.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            var teamData = userTeams[index].data() as Map<String, dynamic>;
            var teamName = teamData['name'] ?? 'Название не указано';
            var captainId = teamData['createdBy'] ?? 'Капитан не указан';
            var members = List<String>.from(teamData['members']);
            return TeamBubble(
              teamName: teamName,
              teamId: userTeams[index].id, // Здесь используйте doc.id
              captainId: captainId,
              members: members,
            );
          },
        );
      },
    );
  }

  Future<List<DocumentSnapshot>> _getUserTeams() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    final currentUserId = currentUser.uid;

    // Получаем команды, где текущий пользователь является капитаном
    final captainTeamsQuery = await FirebaseFirestore.instance
        .collection('teams')
        .where('createdBy', isEqualTo: currentUserId)
        .get();

    // Получаем команды, где текущий пользователь является участником
    final memberTeamsQuery = await FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: currentUserId)
        .get();

    // Объединяем списки команд
    final captainTeams = captainTeamsQuery.docs;
    final memberTeams = memberTeamsQuery.docs;

    return [...captainTeams, ...memberTeams];
  }
}
