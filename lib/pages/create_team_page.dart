import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_text_field.dart';

class CreateTeam extends StatefulWidget {
  final List<String> receiverUserEmails;
  final List<String> receiverUserIds;
  const CreateTeam({
    super.key,
    required this.receiverUserEmails,
    required this.receiverUserIds,
  });

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final groupChatNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        MyTextField(
            controller: groupChatNameController,
            hintText: 'Название команды',
            obscureText: true),
      ],
    ));
  }
}
