import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTeamService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTeam(
    String teamName,
    List<String> selectedUsers,
  ) async {
    final String? captainId = _auth.currentUser?.uid;

    if (teamName.isNotEmpty && captainId != null && selectedUsers.isNotEmpty) {
      // Добавляем email текущего пользователя в список выбранных пользователей
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(captainId)
          .get();
      selectedUsers.add(userDoc['email']);

      DocumentReference teamRef =
          FirebaseFirestore.instance.collection('teams').doc();

      Map<String, dynamic> teamData = {
        'id': teamRef.id,
        'name': teamName,
        'members': selectedUsers,
        'createdBy': captainId,
      };

      try {
        await teamRef.set(teamData);
        print('Создана новая команда:');
        print(teamData);
      } catch (e) {
        print('Ошибка при сохранении данных в Firestore: $e');
        rethrow; // Пробросим исключение дальше
      }
    } else {
      throw Exception(
          'Название команды и идентификатор капитана не могут быть пустыми, и должны быть выбраны участники');
    }
  }
}
