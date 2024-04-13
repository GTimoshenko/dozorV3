import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
