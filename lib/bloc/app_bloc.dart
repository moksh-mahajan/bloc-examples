import 'dart:math';
import 'dart:typed_data';

import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/bloc/bloc_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String>);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(
          const AppState.empty(),
        ) {
    on<LoadNextUrlEvent>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          data: null,
          error: null,
        ),
      );
      final url = (urlPicker ?? _pickRandomUrl)(urls);
      print('Picked url: $url');
      if (waitBeforeLoading != null) {
        await Future.delayed(waitBeforeLoading);
      }
      try {
        final data = await (urlLoader ?? _loadUrl)(url);
        emit(
          AppState(
            isLoading: false,
            data: data,
            error: null,
          ),
        );
      } catch (e) {
        emit(
          AppState(
            isLoading: false,
            data: null,
            error: e,
          ),
        );
      }
    });
  }

  String _pickRandomUrl(Iterable<String> urls) => urls.getRandomElement();

  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((byteData) => byteData.buffer.asUint8List());
}
