import 'package:bloc_test/bloc_test.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/deck/deck.dart';
import 'package:mockingjay/mockingjay.dart';

class MockDecksRepository extends Mock implements DecksRepository {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('DeckCubit', () {
    late DecksRepository decksRepository;
    late DeckCubit deckCubit;

    setUp(() {
      decksRepository = MockDecksRepository();
      deckCubit = DeckCubit(decksRepository: decksRepository, deckIndex: 0);
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => DeckCubit(decksRepository: decksRepository, deckIndex: 0),
          returnsNormally,
        );
      });

      test('initial state is correct', () {
        expect(deckCubit.state, equals(const DeckState(deckIndex: 0)));
      });
    });

    group('readDeck', () {
      const deck = Deck(name: 'name');

      blocTest<DeckCubit, DeckState>(
        'emits state with success status and deck',
        setUp: () {
          when(() => decksRepository.read(any())).thenAnswer((_) => deck);
        },
        build: () => deckCubit,
        act: (cubit) => cubit.readDeck(0),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0),
          const DeckState(
              status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => decksRepository.read(0)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits state with failure status when cannot find deck',
        setUp: () {
          when(() => decksRepository.read(any())).thenAnswer((_) => null);
        },
        build: () => deckCubit,
        act: (cubit) => cubit.readDeck(0),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0),
          const DeckState(status: DeckStatus.failure, deckIndex: 0),
        ],
        verify: (_) {
          verify(() => decksRepository.read(0)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits state with failure status when exception occurs',
        setUp: () {
          when(() => decksRepository.read(any())).thenThrow(Exception());
        },
        build: () => deckCubit,
        act: (cubit) => cubit.readDeck(0),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0),
          const DeckState(status: DeckStatus.failure, deckIndex: 0),
        ],
        verify: (_) {
          verify(() => decksRepository.read(0)).called(1);
        },
      );
    });

    group('onLayoutChanged', () {
      const deck = Deck(name: 'name', entryLayout: EntryLayout.horizontal);
      const updatedDeck =
          Deck(name: 'name', entryLayout: EntryLayout.expansion);
      blocTest<DeckCubit, DeckState>(
        'emits state with updated entry layout',
        setUp: () {
          when(() => decksRepository.update(any(), any()))
              .thenAnswer((_) async {});
        },
        build: () => deckCubit,
        seed: () => const DeckState(
            status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onLayoutChanged(EntryLayout.expansion),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          const DeckState(
              status: DeckStatus.loadSuccess, deckIndex: 0, deck: updatedDeck),
        ],
        verify: (_) {
          verify(() => decksRepository.update(0, updatedDeck)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits state with failure when exception occurs',
        setUp: () {
          when(() => decksRepository.update(any(), any()))
              .thenThrow(Exception());
        },
        build: () => deckCubit,
        seed: () => const DeckState(
            status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onLayoutChanged(EntryLayout.expansion),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          const DeckState(status: DeckStatus.failure, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => decksRepository.update(0, updatedDeck)).called(1);
        },
      );
    });

    group('deleteDeck', () {
      const deck = Deck(name: 'name', entryLayout: EntryLayout.horizontal);

      blocTest<DeckCubit, DeckState>(
        'emits state with delete success status',
        setUp: () {
          when(() => decksRepository.delete(any())).thenAnswer((_) async {});
        },
        build: () => deckCubit,
        seed: () => const DeckState(
            status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.deleteDeck(),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          const DeckState(
              status: DeckStatus.deleteSuccess, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => decksRepository.delete(0)).called(1);
        },
      );

      blocTest<DeckCubit, DeckState>(
        'emits state with failure status when exception occurs',
        setUp: () {
          when(() => decksRepository.delete(any())).thenThrow(Exception());
        },
        build: () => deckCubit,
        seed: () => const DeckState(
            status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck),
        act: (cubit) => cubit.deleteDeck(),
        expect: () => [
          const DeckState(status: DeckStatus.loading, deckIndex: 0, deck: deck),
          const DeckState(status: DeckStatus.failure, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => decksRepository.delete(0)).called(1);
        },
      );
    });
  });
}
