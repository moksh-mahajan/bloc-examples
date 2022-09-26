import 'package:bloc_examples/views/email_field.dart';
import 'package:bloc_examples/views/login_button.dart';
import 'package:bloc_examples/views/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;

  const LoginView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailField(controller: emailController),
          PasswordField(controller: passwordController),
          LoginButton(
              emailController: emailController,
              passwordController: passwordController,
              onLoginTapped: onLoginTapped,)
        ],
      ),
    );
  }
}
