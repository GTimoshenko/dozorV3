import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamBubble extends StatelessWidget {
  final String teamName;
  final String teamId;
  final String captainId;
  final List<String> members;

  const TeamBubble({
    Key? key,
    required this.teamName,
    required this.teamId,
    required this.captainId,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white, // Пример цвета, можно изменить на свой вкус
        border: Border.all(color: Colors.black), // Черная окантовка
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Команда: $teamName',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            'ID команды: $teamId',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 5),
          FutureBuilder<String>(
            future: getCaptainEmail(captainId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'Капитан: Загрузка...',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Капитан: Ошибка: ${snapshot.error}',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              return Text(
                'Капитан: ${snapshot.data}',
                style: TextStyle(fontSize: 15, color: Colors.black),
              );
            },
          ),
          SizedBox(height: 5),
          Text(
            'Участники: ${members.join(', ')}',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<String> getCaptainEmail(String captainId) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(captainId)
          .get();
      if (userDoc.exists) {
        return userDoc['email'];
      } else {
        return 'Email капитана не найден';
      }
    } catch (e) {
      print('Ошибка при получении email капитана: $e');
      return 'Ошибка при получении email капитана';
    }
  }
}
