// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:bloc_examples/auth/auth_errors.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    required this.authError,
  });

  User? get user {
    if (this is AppStateLoggedIn) {
      return (this as AppStateLoggedIn).user;
    }
    return null;
  }

  Iterable<Reference>? get images {
    if (this is AppStateLoggedIn) {
      return (this as AppStateLoggedIn).images;
    }
    return null;
  }
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required bool isLoading,
    AuthError? authError,
    required this.user,
    required this.images,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );

  @override
  bool operator ==(other) {
    if (other is AppStateLoggedIn) {
      return isLoading == other.isLoading &&
          authError == other.authError &&
          user.uid == other.user.uid &&
          images.length != other.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn(user: $user, images: $images)';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );

  @override
  String toString() =>
      'AppStateLoggedOut(user: $isLoading, images: $authError)';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );
}
