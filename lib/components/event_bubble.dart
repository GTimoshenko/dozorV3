import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventBubble extends StatelessWidget {
  final String eventId;
  final String createdBy;
  final String eventName;
  final List<String> members;
  final bool isActive;
  final DateTime start;

  const EventBubble({
    Key? key,
    required this.eventId,
    required this.createdBy,
    required this.eventName,
    required this.members,
    required this.isActive,
    required this.start,
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
            'Событие: $eventName',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            'ID события: $eventId',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 5),
          FutureBuilder<String>(
            future: getCreatorEmail(createdBy),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'Организатор: Загрузка...',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Организатор: Ошибка: ${snapshot.error}',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              return Text(
                'Организатор: ${snapshot.data}',
                style: TextStyle(fontSize: 15, color: Colors.black),
              );
            },
          ),
          SizedBox(height: 5),
          Text(
            'Создано: $start',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(height: 5),
          FutureBuilder<List<String>>(
            future: getEmailsFromIds(members),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'Участники: Загрузка...',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Участники: Ошибка: ${snapshot.error}',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                );
              }
              return Text(
                'Участники: ${snapshot.data!.join(', ')}',
                style: TextStyle(fontSize: 15, color: Colors.black),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> getCreatorEmail(String createdBy) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(createdBy)
          .get();
      if (userDoc.exists) {
        return userDoc['email'];
      } else {
        return 'Email организатора не найден';
      }
    } catch (e) {
      print('Ошибка при получении email организатора: $e');
      return 'Ошибка при получении email организатора';
    }
  }

  Future<List<String>> getEmailsFromIds(List<String> members) async {
    List<String> names = [];
    try {
      for (String teamId in members) {
        var teamDoc = await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamId)
            .get();
        if (teamDoc.exists) {
          names.add(teamDoc['name']);
        } else {
          names.add('Email пользователя не найден');
        }
      }
    } catch (e) {
      print('Ошибка при получении email пользователей: $e');
      names = List.filled(
          members.length, 'Ошибка при получении email пользователя');
    }
    return names;
  }
}
