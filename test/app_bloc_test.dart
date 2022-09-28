import 'dart:typed_data';

import 'package:bloc_examples/bloc/app_bloc.dart';
import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/bloc/bloc_events.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

enum Errors { dummy }

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

void main() {
  blocTest<AppBloc, AppState>(
    'Intial state of the bloc show be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(appBloc.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load a url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) {
      bloc.add(const LoadNextUrlEvent());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text1Data,
        error: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Throw an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) {
      bloc.add(const LoadNextUrlEvent());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Test the ability to load more than one url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (bloc) {
      bloc.add(const LoadNextUrlEvent());
      bloc.add(const LoadNextUrlEvent());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
    ],
  );
}
