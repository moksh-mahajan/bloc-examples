import 'package:bloc_examples/bloc/app_bloc.dart';
import 'package:bloc_examples/bloc/app_event.dart';
import 'package:bloc_examples/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'mokshmahajan008@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'abcd1234'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here...',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              autocorrect: false,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here...',
              ),
              obscureText: true,
              keyboardAppearance: Brightness.dark,
              autocorrect: false,
            ),
            TextButton(
              onPressed: () => context.read<AppBloc>().add(
                    AppEventLogIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  ),
              child: const Text(
                'Login',
              ),
            ),
            TextButton(
              onPressed: () => context.read<AppBloc>().add(
                    const AppEventGoToRegistration(),
                  ),
              child: const Text(
                'Not registered yet? Register here',
              ),
            )
          ],
        ),
      ),
    );
  }
}
