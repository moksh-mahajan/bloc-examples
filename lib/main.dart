import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(children: [
            TextButton(
              onPressed: () => context.read<PersonsBloc>().add(
                    const LoadPersonsAction(
                      url: PersonUrl.persons1,
                    ),
                  ),
              child: Text('Load json #1'),
            ),
            TextButton(
              onPressed: () => context.read<PersonsBloc>().add(
                    const LoadPersonsAction(
                      url: PersonUrl.persons2,
                    ),
                  ),
              child: Text('Load json #2'),
            )
          ]),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: ((previousResult, currentResult) =>
                  previousResult?.persons != currentResult?.persons),
              builder: ((context, fetchResult) {
                fetchResult?.log();
                final persons = fetchResult?.persons;
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  },
                  itemCount: persons.length,
                ));
              }))
        ],
      ),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() {
    return 'Person(name: $name, age: $age)';
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult(isRetrievedFromCache: $isRetrievedFromCache, persons: $persons)';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final personUrl = event.url;
      if (_cache.containsKey(personUrl)) {
        final cachedPersons = _cache[personUrl]!;
        final result = FetchResult(
          persons: cachedPersons,
          isRetrievedFromCache: true,
        );
        emit(result);
      } else {
        final persons = await getPersons(personUrl.url);
        _cache[personUrl] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;

  const LoadPersonsAction({required this.url}) : super();
}

enum PersonUrl {
  persons1('http://192.168.1.61:5500/lib/api/persons1.json'),
  persons2('http://192.168.1.61:5500/lib/api/persons2.json');

  final String url;
  const PersonUrl(this.url);
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
