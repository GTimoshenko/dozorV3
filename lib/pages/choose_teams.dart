import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/my_event_page.dart';

class ChooseTeams extends StatefulWidget {
  final TextEditingController eventName;
  const ChooseTeams({Key? key, required this.eventName}) : super(key: key);

  @override
  State<ChooseTeams> createState() => _ChooseTeamsState();
}

class _ChooseTeamsState extends State<ChooseTeams> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  List<String> selectedTeams = [];

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyboard, // Hide keyboard when tapping anywhere on the screen
      child: Scaffold(
        appBar: AppBar(
          title: Text('Выберите команды'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                createEvent(context, selectedTeams);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchField(),
            Expanded(child: _createTeamList()),
          ],
        ),
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
              hintText: 'Поиск команд',
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

  Widget _createTeamList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('teams').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredTeams = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return (data['name'] as String).toLowerCase().contains(_searchText);
        }).toList();

        return ListView.builder(
          itemCount: filteredTeams.length,
          itemBuilder: (context, index) {
            return _createTeamListItem(filteredTeams[index]);
          },
        );
      },
    );
  }

  Widget _createTeamListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String teamName = data['name'];
    String teamId = doc.id;

    return ListTile(
      title: Text(teamName),
      onTap: () {
        setState(() {
          if (selectedTeams.contains(teamId)) {
            selectedTeams.remove(teamId);
          } else {
            selectedTeams.add(teamId);
          }
        });
      },
      leading: Checkbox(
        value: selectedTeams.contains(teamId),
        onChanged: (bool? value) {
          setState(() {
            if (value != null && value) {
              selectedTeams.add(teamId);
            } else {
              selectedTeams.remove(teamId);
            }
          });
        },
      ),
    );
  }

  void createEvent(
    BuildContext context,
    List<String> selectedTeams,
  ) async {
    final String? userId = _auth.currentUser?.uid;

    if (userId != null && selectedTeams.isNotEmpty) {
      try {
        DateTime now = DateTime.now();
        DocumentReference eventRef =
            FirebaseFirestore.instance.collection('events').doc();

        Map<String, dynamic> eventData = {
          'id': eventRef.id,
          'createdBy': userId,
          'eventName': widget.eventName.text,
          'members': selectedTeams,
          'isActive': true,
          'start': now,
        };

        await eventRef.set(eventData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyEventPage(
              eventId: eventData['id'],
            ),
          ),
        );
      } catch (e) {
        print('Ошибка при сохранении данных в Firestore: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Выберите хотя бы одну команду'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
