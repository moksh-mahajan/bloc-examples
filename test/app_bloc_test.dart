import 'package:bloc_examples/apis/login_api.dart';
import 'package:bloc_examples/apis/notes_api.dart';
import 'package:bloc_examples/bloc/actions.dart';
import 'package:bloc_examples/bloc/app_bloc.dart';
import 'package:bloc_examples/bloc/app_state.dart';
import 'package:bloc_examples/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3')
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToBeReturnedForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToBeReturnedForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.foobar(),
        notesToBeReturnedForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToBeReturnedForAcceptedLoginHandle;
    }
    return null;
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToBeReturned;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToBeReturned,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToBeReturned = const LoginHandle.foobar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToBeReturned;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Intial state of the bloc should be Appstate.empty()',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
    ),
    verify: (bloc) => expect(
      bloc.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Can we login with correct credentials?',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foobar@foo.com',
          acceptedPassword: 'foobar',
          handleToBeReturned: LoginHandle(token: 'ABC')),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'foobar@foo.com',
        password: 'foobar',
      ),
    ),
    expect: () => const [
      AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      AppState(
        isLoading: false,
        loginError: null,
        loginHandle: LoginHandle(token: 'ABC'),
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'We should not be able to login with invalid credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foobar@bar.com',
          acceptedPassword: 'baz',
          handleToBeReturned: LoginHandle(token: 'ABC')),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'foobar@foo.com',
        password: 'foobar',
      ),
    ),
    expect: () => const [
      AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      AppState(
        isLoading: false,
        loginError: LoginError.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'Load some notes with a valid login handle',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foobar@foo.com',
          acceptedPassword: 'foobar',
          handleToBeReturned: LoginHandle.foobar()),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: LoginHandle.foobar(),
        notesToBeReturnedForAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'foobar@foo.com',
          password: 'foobar',
        ),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => const [
      AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      AppState(
        isLoading: false,
        loginError: null,
        loginHandle: LoginHandle.foobar(),
        fetchedNotes: null,
      ),
      AppState(
        isLoading: true,
        loginError: null,
        loginHandle: LoginHandle.foobar(),
        fetchedNotes: null,
      ),
      AppState(
        isLoading: false,
        loginError: null,
        loginHandle: LoginHandle.foobar(),
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
