import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/bloc/bloc_events.dart';
import 'package:bloc_examples/extensions/streams/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatefulWidget {
  const AppBlocView({Key? key}) : super(key: key);

  @override
  State<AppBlocView<T>> createState() => _AppBlocViewState<T>();
}

class _AppBlocViewState<T extends AppBloc> extends State<AppBlocView<T>> {
  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    )
        .startWith(
      const LoadNextUrlEvent(),
    )
        .forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  void initState() {
    startUpdatingBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(child: Text('An error occured!: ${state.error}'));
          } else if (state.data != null) {
            return Image.memory(
              state.data!,
              fit: BoxFit.fitHeight,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
