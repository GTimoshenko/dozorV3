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
        color: Color.fromARGB(255, 118, 108, 137),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
