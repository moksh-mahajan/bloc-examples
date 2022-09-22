import 'package:bloc_examples/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}

const persons1Url = 'http://192.168.1.61:5500/lib/api/persons1.json';
const persons2Url = 'http://192.168.1.61:5500/lib/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);
