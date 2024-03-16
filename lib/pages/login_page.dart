import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//авторизация пользователя 
void logIn() {

}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent[1000],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.beenhere, 
                  size: 80
                  ),
                  
                Text("Beesiness broker"),
                const SizedBox(height: 70),
                Text("Давно не виделись!"), 
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController, 
                  hintText: 'Email', 
                  obscureText: false
                  ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController, 
                  hintText: 'Пароль', 
                  obscureText: true
                  ),
                const SizedBox(height: 15),
                MyButton(onTap: logIn, text: "Войти"),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Нет аккаунта?"),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Зарегистрируйтесь",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}