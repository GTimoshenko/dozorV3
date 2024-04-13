import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ГЛАВНАЯ"),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: _createUserList(),
    );
  }

  //вывести список всех пользователей кроме текущего
  Widget _createUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('ошибка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _createUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // создание сущности пользователя в списке пользователя
  Widget _createUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    //вывести всех пользователей кроме текущего
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //перебросить в чат
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserId: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
