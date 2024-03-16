import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
  
}

//регистрация пользователя 
void signUp() {

}
class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                Text("Давайте создадим вам аккаунт!"),
                const SizedBox(height: 15),
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
                MyTextField(
                  controller: confirmPasswordController, 
                  hintText: 'Повторите пароль', 
                  obscureText: true
                  ),
                const SizedBox(height: 15),
                MyButton(onTap: signUp, text: "Зарегистрироваться"),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Уже есть аккаунт?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Войти",
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