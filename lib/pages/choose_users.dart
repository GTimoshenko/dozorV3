import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'chat_page.dart';

class ChooseUsers extends StatefulWidget {
  final TextEditingController teamName;
  const ChooseUsers({Key? key, required this.teamName}) : super(key: key);

  @override
  State<ChooseUsers> createState() => _ChooseUsersState();
}

class _ChooseUsersState extends State<ChooseUsers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  List<String> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Группа'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {
              // Обработка нажатия на стрелку
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _createUserList()),
        ],
      ),
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

  Widget _createUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Ошибка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        var filteredUsers = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          return _auth.currentUser!.email != data['email'] &&
              (data['email'] as String).toLowerCase().contains(_searchText);
        }).toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return _createUserListItem(filteredUsers[index]);
          },
        );
      },
    );
  }

  Widget _createUserListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    String userEmail = data['email'];

    return ListTile(
      title: Text(userEmail),
      leading: Checkbox(
        value: selectedUsers.contains(userEmail),
        onChanged: (bool? value) {
          setState(() {
            if (value != null && value) {
              selectedUsers.add(userEmail);
            } else {
              selectedUsers.remove(userEmail);
            }
          });
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: userEmail,
              receiverUserId: data['uid'],
            ),
          ),
        );
      },
    );
  }
}
