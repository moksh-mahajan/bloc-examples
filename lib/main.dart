import 'dart:convert';
import 'dart:io';

import 'package:bloc_examples/bloc/bloc_actions.dart';
import 'package:bloc_examples/bloc/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'bloc/persons_bloc.dart';

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
                      url: persons1Url,
                      loader: getPersons,
                    ),
                  ),
              child: Text('Load json #1'),
            ),
            TextButton(
              onPressed: () => context.read<PersonsBloc>().add(
                    const LoadPersonsAction(
                      url: persons2Url,
                      loader: getPersons,
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

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
