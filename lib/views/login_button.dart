import 'package:bloc_examples/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bloc_examples/strings.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(login),
      onPressed: () {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionBuilder: () => {
              ok: true,
            },
          );
        } else {
          onLoginTapped(email, password);
        }
      },
    );
  }
}
