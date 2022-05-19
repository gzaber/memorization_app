import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

void main() {
  group('HomeCubit', () {
    late DeckRepository repository;

    setUp(() {
      repository = MockDeckRepository();
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => HomeCubit(repository), returnsNormally);
      });

      test('initial state is HomeLoading', () {
        final homeCubit = HomeCubit(repository);
        expect(homeCubit.state, HomeLoading());
      });
    });

    group('readAllDecks', () {
      final List<Deck> decks = [const Deck(name: 'name', url: 'url')];
      blocTest<HomeCubit, HomeState>(
        'emits [HomeLoading, HomeSuccess] when successful',
        setUp: () {
          when(() => repository.readAllDecks()).thenAnswer((_) => decks);
        },
        build: () => HomeCubit(repository),
        act: (cubit) => cubit.readAllDecks(),
        expect: () => <HomeState>[HomeLoading(), HomeSuccess(decks)],
        verify: (_) {
          verify(() => repository.readAllDecks()).called(1);
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits [HomeLoading, HomeFailure] when failure',
        setUp: () {
          when(() => repository.readAllDecks()).thenThrow(Exception('failure'));
        },
        build: () => HomeCubit(repository),
        act: (cubit) => cubit.readAllDecks(),
        expect: () =>
            <HomeState>[HomeLoading(), const HomeFailure('Exception: failure')],
        verify: (_) {
          verify(() => repository.readAllDecks()).called(1);
        },
      );
    });
  });
}
