import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/chat_bubble.dart';
import 'package:flutter_application_1/pages/events_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:flutter_application_1/pages/team_page.dart';
import 'package:flutter_application_1/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String pageName = "Чаты";
  var pages = [
    HomePage(),
    EventPage(),
    TeamPage(),
    ProfilePage(),
  ];

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageName,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout_rounded),
          ),
        ],
        centerTitle: true,
      ),
      body: _currentIndex == 0 ? _buildBody() : pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: "Мессенджер",
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: "Мероприятия",
            icon: Icon(Icons.event),
          ),
          BottomNavigationBarItem(
            label: "Моя команда",
            icon: Icon(Icons.people_rounded),
          ),
          BottomNavigationBarItem(
            label: "Профиль",
            icon: Icon(Icons.person),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemSelected,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchField(),
        Expanded(child: _createUserList()),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск пользователей',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value.toLowerCase();
              });
            },
          ),
          if (_searchController.text.isNotEmpty)
            Positioned(
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchText = '';
                  });
                },
                child: Icon(Icons.clear),
              ),
            ),
        ],
      ),
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      pageName = "Чаты";
      _searchText = ""; // Сбросить текст поиска при переходе на страницу "Чаты"
    }
    if (_currentIndex == 1) {
      pageName = "Мероприятия";
    }
    if (_currentIndex == 2) {
      pageName = "Команды";
    }
    if (_currentIndex == 3) {
      pageName = "Мой профиль";
    }
  }

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

        var filteredUsers = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          return _auth.currentUser!.email != data['email'] &&
              (data['email'] as String).toLowerCase().contains(_searchText);
        }).toList();

        return ListView(
          shrinkWrap: true,
          physics:
              ClampingScrollPhysics(), // Отключение прокрутки для списка пользователей
          children: filteredUsers
              .map<Widget>((doc) => _createUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _createUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: ChatBubble(message: data['email']),
        onTap: () {
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
