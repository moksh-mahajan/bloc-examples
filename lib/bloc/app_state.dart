import 'package:flutter/foundation.dart' show immutable;
import 'package:collection/collection.dart';
import 'package:bloc_examples/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  @override
  String toString() {
    return {
      'isLoading': isLoading,
      'loginError': loginError,
      'loginHandle': loginHandle,
      'fetchedNotes': fetchedNotes
    }.toString();
  }

  @override
  bool operator ==(covariant AppState other) {
    final otherEqualities = isLoading == other.isLoading &&
        loginError == other.loginError &&
        loginHandle == other.loginHandle;
    if (fetchedNotes == null && other.fetchedNotes == null) {
      return otherEqualities;
    }
    return otherEqualities &&
        (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? false);
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginError,
        loginHandle,
        fetchedNotes,
      );
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
        this,
        other,
      );
}
