import 'package:bloc_examples/bloc/bloc_actions.dart';
import 'package:bloc_examples/bloc/person.dart';
import 'package:bloc_examples/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(
    name: 'Moksh',
    age: 24,
  ),
  Person(
    name: 'Mahima',
    age: 25,
  )
];

const mockedPersons2 = [
  Person(
    name: 'Puneet',
    age: 25,
  ),
  Person(
    name: 'Pryanshi',
    age: 23,
  )
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    // Setup will run before every test
    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
        },
        expect: () => const [
              FetchResult(
                persons: mockedPersons1,
                isRetrievedFromCache: false,
              ),
              FetchResult(
                persons: mockedPersons1,
                isRetrievedFromCache: true,
              ),
            ]);

    blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => const [
              FetchResult(
                persons: mockedPersons2,
                isRetrievedFromCache: false,
              ),
              FetchResult(
                persons: mockedPersons2,
                isRetrievedFromCache: true,
              ),
            ]);
  });
}
