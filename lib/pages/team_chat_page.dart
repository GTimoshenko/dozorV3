import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/chat_bubble.dart';
import 'package:flutter_application_1/components/input_text_field.dart';
import 'package:flutter_application_1/services/chat/group_chat_service.dart';

class TeamChatPage extends StatefulWidget {
  final List<String> receiverUserEmails;
  final List<String> receiverUserIds;
  final String teamName;

  const TeamChatPage({
    Key? key,
    required this.receiverUserEmails,
    required this.receiverUserIds,
    required this.teamName,
  }) : super(key: key);

  @override
  State<TeamChatPage> createState() => _TeamChatPageState();
}

class _TeamChatPageState extends State<TeamChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final GroupChatService _groupChatService = GroupChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.teamName}')),
      body: Column(
        children: [
          Expanded(
            child: _createMessageList(),
          ),
          _createMessageInput(),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget _createMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomInputTextField(
              controller: _messageController,
              hintText: 'Сообщение',
              obscureText: false,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _createMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _groupChatService.getMessagesStream(widget.receiverUserIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Сортируем сообщения по timestamp в прямом порядке
        final sortedMessages = snapshot.data!.docs
            .where((document) =>
                widget.receiverUserIds.contains(document['senderId']) &&
                document['teamName'] ==
                    widget
                        .teamName) // Проверяем, что поле teamName совпадает с переданным в виджет
            .toList()
          ..sort((a, b) => (a['timestamp'] as Timestamp)
              .compareTo(b['timestamp'] as Timestamp));

        return ListView(
          // Используем отсортированные сообщения
          children: sortedMessages
              .map((document) => _createMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _createMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (data['senderEmail'] != null) // Check if senderEmail exists
              Text(data['senderEmail']),
            const SizedBox(height: 7),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _groupChatService.sendMessage(
        widget.receiverUserIds,
        _messageController.text,
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserEmails,
        widget.teamName,
      );

      _messageController.clear();
    }
  }
}
