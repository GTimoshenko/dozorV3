import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  const CustomInputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: 32,
        maxLines: 1,
        obscureText: obscureText,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          isDense: true,
          labelText: hintText,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    );
  }
}
