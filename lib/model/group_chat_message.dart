import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatMessage {
  String senderId;
  String senderEmail;
  List<String> receiverIds;
  List<String>
      receiverEmails; // Add this line to include the receiverEmails list
  String message;
  Timestamp timestamp;

  GroupChatMessage({
    required this.senderId,
    required this.senderEmail,
    required this.receiverIds,
    required this.receiverEmails, // Add this line to include the receiverEmails list
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverIds': receiverIds,
      'receiverEmails':
          receiverEmails, // Add this line to include the receiverEmails list
      'message': message,
      'timestamp': timestamp,
    };
  }
}
