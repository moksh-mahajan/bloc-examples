import 'package:bloc_examples/bloc/app_event.dart';
import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/dialogs/auth_error.dart';
import 'package:bloc_examples/loading/loading_screen.dart';
import 'package:bloc_examples/views/login_view.dart';
import 'package:bloc_examples/views/photo_gallery_view.dart';
import 'package:bloc_examples/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Material App',
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;
            if (authError != null) {
              showAuthError(context: context, error: authError);
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            }
            if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            }
            if (state is AppStateIsInRegistrationView) {
              return const RegisterView();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
