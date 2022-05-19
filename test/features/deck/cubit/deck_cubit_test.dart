import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('DeckCubit', () {
    late DeckRepository repository;
    late DeckCubit deckCubit;

    setUp(() {
      repository = MockDeckRepository();
      deckCubit = DeckCubit(repository);
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => DeckCubit(repository), returnsNormally);
      });

      test('initial state is correct', () {
        final deckCubit = DeckCubit(repository);
        expect(
            deckCubit.state,
            const DeckState(
                status: DeckStatus.loading,
                deckIndex: null,
                deck: Deck(name: '', url: ''),
                errorMessage: ''));
      });
    });

    group('readDeck', () {
      Deck deck = const Deck(name: 'name', url: 'url');

      blocTest<DeckCubit, DeckState>(
        'emits [loading, loadSuccess] when successful',
        setUp: () {
          when(() => repository.readDeck(any())).thenAnswer((_) => deck);
        },
        build: () => deckCubit,
        act: (cubit) => cubit.readDeck(2),
        expect: () => <DeckState>[
          const DeckState(status: DeckStatus.loading),
          DeckState(status: DeckStatus.loadSuccess, deckIndex: 2, deck: deck),
        ],
        verify: (_) {
          verify(() => repository.readDeck(2)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits [loading, failure] when throws exception',
        setUp: () {
          when(() => repository.readDeck(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => deckCubit,
        act: (cubit) => cubit.readDeck(2),
        expect: () => <DeckState>[
          const DeckState(status: DeckStatus.loading),
          const DeckState(
              status: DeckStatus.failure, errorMessage: 'Exception: failure'),
        ],
        verify: (_) {
          verify(() => repository.readDeck(2)).called(1);
        },
      );
    });

    group('onLayoutChanged', () {
      Deck oldDeck =
          const Deck(name: 'name', url: 'url', entryLayout: EntryLayout.row);
      Deck newDeck = const Deck(
          name: 'name', url: 'url', entryLayout: EntryLayout.expansionTile);
      blocTest<DeckCubit, DeckState>(
        'emits [loading, loadSuccess] when successful',
        setUp: () {
          when(() => repository.updateDeck(any(), any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => deckCubit,
        seed: () => DeckState(
            deckIndex: 0, status: DeckStatus.loadSuccess, deck: oldDeck),
        act: (cubit) => cubit.onLayoutChanged(EntryLayout.expansionTile),
        expect: () => <DeckState>[
          DeckState(status: DeckStatus.loading, deckIndex: 0, deck: oldDeck),
          DeckState(
              status: DeckStatus.loadSuccess, deckIndex: 0, deck: newDeck),
        ],
        verify: (_) {
          verify(() => repository.updateDeck(0, newDeck)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits [loading, failure]  when throws exception',
        setUp: () {
          when(() => repository.updateDeck(any(), any()))
              .thenThrow(Exception('failure'));
        },
        build: () => deckCubit,
        seed: () => DeckState(
            deckIndex: 0, status: DeckStatus.loadSuccess, deck: oldDeck),
        act: (cubit) => cubit.onLayoutChanged(EntryLayout.expansionTile),
        expect: () => <DeckState>[
          DeckState(status: DeckStatus.loading, deckIndex: 0, deck: oldDeck),
          DeckState(
              status: DeckStatus.failure,
              deckIndex: 0,
              deck: oldDeck,
              errorMessage: 'Exception: failure'),
        ],
        verify: (_) {
          verify(() => repository.updateDeck(0, newDeck)).called(1);
        },
      );
    });

    group('deleteDeck', () {
      Deck deck =
          const Deck(name: 'name', url: 'url', entryLayout: EntryLayout.row);
      blocTest<DeckCubit, DeckState>(
        'emits [loading, deleteSuccess] when successful',
        setUp: () {
          when(() => repository.deleteDeck(any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => deckCubit,
        seed: () =>
            DeckState(status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.deleteDeck(),
        expect: () => <DeckState>[
          DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          DeckState(status: DeckStatus.deleteSuccess, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => repository.deleteDeck(0)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits [loading, failure] when failure',
        setUp: () {
          when(() => repository.deleteDeck(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => deckCubit,
        seed: () =>
            DeckState(status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.deleteDeck(),
        expect: () => <DeckState>[
          DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          DeckState(
              status: DeckStatus.failure,
              deckIndex: 0,
              deck: deck,
              errorMessage: 'Exception: failure'),
        ],
        verify: (_) {
          verify(() => repository.deleteDeck(0)).called(1);
        },
      );
    });
  });
}
