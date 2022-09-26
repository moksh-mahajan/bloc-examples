import 'package:bloc_examples/apis/login_api.dart';
import 'package:bloc_examples/apis/notes_api.dart';
import 'package:bloc_examples/bloc/actions.dart';
import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      ((event, emit) async {
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );
        final loginHandle =
            await loginApi.login(email: event.email, password: event.password);
        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginError.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      }),
    );

    on<LoadNotesAction>((event, emit) async {
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.foobar()) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginError.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      } else {
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      }
    });
  }
}
