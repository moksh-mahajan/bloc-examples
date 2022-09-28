import 'package:bloc_examples/bloc/top_bloc.dart';
import 'package:bloc_examples/models/constants.dart';
import 'package:bloc_examples/views/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bottom_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => TopBloc(
                urls: images,
              ),
            ),
            BlocProvider(
              create: (_) => BottomBloc(
                urls: images,
              ),
            ),
          ],
          child: Column(
            children: const [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
