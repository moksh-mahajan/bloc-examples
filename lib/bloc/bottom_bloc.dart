import 'package:bloc_examples/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? randomUrlPicker,
    required Iterable<String> urls,
  }) : super(
          urls: urls,
          waitBeforeLoading: waitBeforeLoading,
          urlPicker: randomUrlPicker,
        );
}
