import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/chat_bubble.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/services/chat/chat_service.dart';
import 'package:flutter_application_1/components/input_text_field.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
    }
    //очистить поле ввода после отправки
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          //сообщения
          Expanded(
            child: _createMessageList(),
          ),

          //ввод пользователя
          _createMessageInput(),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  //create message list
  Widget _createMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _createMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //create message item
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
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle_rounded),
            Text(data['senderEmail']),
            const SizedBox(height: 7),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  //create message input
  Widget _createMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: CustomInputTextField(
            controller: _messageController,
            obscureText: false,
            hintText: "Сообщение",
            textCapitalization: TextCapitalization.words,
          )),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send_rounded,
              size: 50,
            ),
          )
        ],
      ),
    );
  }
}
