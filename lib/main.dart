import 'package:bloc_examples/apis/login_api.dart';
import 'package:bloc_examples/apis/notes_api.dart';
import 'package:bloc_examples/bloc/actions.dart';
import 'package:bloc_examples/dialogs/generic_dialog.dart';
import 'package:bloc_examples/dialogs/loading_screen.dart';
import 'package:bloc_examples/models.dart';
import 'package:bloc_examples/strings.dart';
import 'package:bloc_examples/views/iterable_list_view.dart';
import 'package:bloc_examples/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(loginApi: LoginApi(), notesApi: NotesApi()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance.show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance.hide();
            }

            // display possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.foobar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, state) {
            return BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                final notes = state.fetchedNotes;
                if (notes == null) {
                  return LoginView(
                    onLoginTapped: (email, password) =>
                        context.read<AppBloc>().add(
                              LoginAction(
                                email: email,
                                password: password,
                              ),
                            ),
                  );
                }
                return notes.toListView();
              },
            );
          },
        ),
      ),
    );
  }
}
