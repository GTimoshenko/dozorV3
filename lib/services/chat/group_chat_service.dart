import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendMessage(
    List<String> receiverIds,
    String message,
    String senderId,
    List<String> receiverUserEmails,
    String teamName,
  ) async {
    final userData = await _firestore.collection('users').get();
    final senderData = userData.docs.firstWhere(
      (user) => user.data()['uid'] == senderId,
    );

    final messageData = {
      'senderIds': receiverIds,
      'senderEmails': receiverUserEmails,
      'message': message,
      'senderId': senderId,
      'senderEmail': senderData.data()['email'],
      'teamName': teamName,
      'timestamp': Timestamp.now(),
    };

    await _firestore.collection('group_messages').add(messageData);
  }

  Stream<QuerySnapshot> getMessagesStream(List<String> receiverIds) {
    return _firestore
        .collection('group_messages')
        .orderBy('timestamp', descending: true)
        .where('senderIds', arrayContainsAny: receiverIds)
        .snapshots();
  }
}
