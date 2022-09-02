import 'package:bloc_test/bloc_test.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:mocktail/mocktail.dart';

class MockCsvRepository extends Mock implements CsvRepository {}

class MockDecksRepository extends Mock implements DecksRepository {}

class MockDeck extends Mock implements Deck {}

void main() {
  group('ManageDeckCubit', () {
    late CsvRepository csvRepository;
    late DecksRepository decksRepository;
    late ManageDeckCubit manageDeckCubit;

    setUp(() {
      csvRepository = MockCsvRepository();
      decksRepository = MockDecksRepository();
      manageDeckCubit = ManageDeckCubit(
        csvRepository: csvRepository,
        decksRepository: decksRepository,
      );
    });

    setUpAll(() {
      registerFallbackValue(MockDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => manageDeckCubit, returnsNormally);
      });

      test('initial state is correct', () {
        expect(manageDeckCubit.state, equals(const ManageDeckState()));
      });
    });

    group('onNameChanged', () {
      const deck = Deck(name: '');
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with updated name',
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onNameChanged('name'),
        expect: () => [
          ManageDeckState(
              status: ManageDeckStatus.initial,
              deckIndex: 0,
              deck: deck.copyWith(name: 'name'))
        ],
      );
    });

    group('onUrlChanged', () {
      const deck = Deck(name: 'name', url: '');
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with updated csv document url',
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onUrlChanged('url'),
        expect: () => [
          ManageDeckState(
              status: ManageDeckStatus.initial,
              deckIndex: 0,
              deck: deck.copyWith(url: 'url'))
        ],
      );
    });

    group('onColorChanged', () {
      const deck = Deck(name: 'name', color: 0xffaabbcc);
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with updated color',
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onColorChanged(0xffddee00),
        expect: () => [
          ManageDeckState(
              status: ManageDeckStatus.initial,
              deckIndex: 0,
              deck: deck.copyWith(color: 0xffddee00))
        ],
      );
    });

    group('onEntriesChanged', () {
      const deck = Deck(name: 'name', entries: []);
      const entries = [
        Entry(title: 'title1', content: 'content1'),
        Entry(title: 'title2', content: 'content2')
      ];

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with updated entries list',
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.onEntriesChanged(entries),
        expect: () => [
          ManageDeckState(
              status: ManageDeckStatus.initial,
              deckIndex: 0,
              deck: deck.copyWith(entries: entries))
        ],
      );
    });

    group('readDeck', () {
      const deck = Deck(name: 'name');
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits initial state state when deck index is null',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(),
        expect: () => [const ManageDeckState()],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with deck index and deck when index is not null',
        setUp: () {
          when(() => decksRepository.read(any())).thenAnswer((_) => deck);
        },
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(index: 0),
        expect: () => [
          const ManageDeckState(status: ManageDeckStatus.loading),
          const ManageDeckState(deckIndex: 0, deck: deck)
        ],
        verify: (_) {
          verify(() => decksRepository.read(0)).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with failure status when exception occurs',
        setUp: () {
          when(() => decksRepository.read(any())).thenThrow(Exception());
        },
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(index: 0),
        expect: () => [
          const ManageDeckState(status: ManageDeckStatus.loading),
          const ManageDeckState(status: ManageDeckStatus.failure)
        ],
        verify: (_) {
          verify(() => decksRepository.read(0)).called(1);
        },
      );
    });

    group('createDeck', () {
      const deck = Deck(name: 'name');

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with empty name status when name is empty',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.createDeck(),
        expect: () =>
            [const ManageDeckState(status: ManageDeckStatus.emptyName)],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with save success status when successfully created deck',
        setUp: () {
          when(() => decksRepository.create(any())).thenAnswer((_) async {});
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.createDeck(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.loading, deckIndex: 0, deck: deck),
          const ManageDeckState(
              status: ManageDeckStatus.saveSuccess, deckIndex: 0, deck: deck)
        ],
        verify: (_) {
          verify(() => decksRepository.create(deck)).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with failure status when exception occurs',
        setUp: () {
          when(() => decksRepository.create(any())).thenThrow(Exception());
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.createDeck(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.loading, deckIndex: 0, deck: deck),
          const ManageDeckState(
              status: ManageDeckStatus.failure, deckIndex: 0, deck: deck)
        ],
        verify: (_) {
          verify(() => decksRepository.create(deck)).called(1);
        },
      );
    });

    group('updateDeck', () {
      const deck = Deck(name: 'name');

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with empty name status when name is empty',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.updateDeck(),
        expect: () =>
            [const ManageDeckState(status: ManageDeckStatus.emptyName)],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with save success status when successfully updated deck',
        setUp: () {
          when(() => decksRepository.update(any(), any()))
              .thenAnswer((_) async {});
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.updateDeck(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.loading, deckIndex: 0, deck: deck),
          const ManageDeckState(
              status: ManageDeckStatus.saveSuccess, deckIndex: 0, deck: deck)
        ],
        verify: (_) {
          verify(() => decksRepository.update(0, deck)).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with failure status when exception occurs',
        setUp: () {
          when(() => decksRepository.update(any(), any()))
              .thenThrow(Exception());
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.updateDeck(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.loading, deckIndex: 0, deck: deck),
          const ManageDeckState(
              status: ManageDeckStatus.failure, deckIndex: 0, deck: deck)
        ],
        verify: (_) {
          verify(() => decksRepository.update(0, deck)).called(1);
        },
      );
    });

    group('readCsv', () {
      const deck = Deck(name: 'name', url: 'csv_url');
      const entry1 = Entry(title: 'title1', content: 'content1');
      const entry2 = Entry(title: 'title2', content: 'content2');
      final csvData = [
        ['title1', 'content1'],
        ['title2', 'content2'],
      ];

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with csv success status and fetched entries',
        setUp: () {
          when(() => csvRepository.fetchData(any()))
              .thenAnswer((_) async => csvData);
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.readCsv(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.csvLoading, deckIndex: 0, deck: deck),
          ManageDeckState(
              status: ManageDeckStatus.csvSuccess,
              deckIndex: 0,
              deck: deck.copyWith(entries: [entry1, entry2])),
        ],
        verify: (_) {
          verify(() => csvRepository.fetchData('csv_url')).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits state with csv failure when exception occured',
        setUp: () {
          when(() => csvRepository.fetchData(any())).thenThrow(Exception());
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deckIndex: 0, deck: deck),
        act: (cubit) => cubit.readCsv(),
        expect: () => [
          const ManageDeckState(
              status: ManageDeckStatus.csvLoading, deckIndex: 0, deck: deck),
          const ManageDeckState(
              status: ManageDeckStatus.csvFailure, deckIndex: 0, deck: deck),
        ],
        verify: (_) {
          verify(() => csvRepository.fetchData('csv_url')).called(1);
        },
      );
    });
  });
}
