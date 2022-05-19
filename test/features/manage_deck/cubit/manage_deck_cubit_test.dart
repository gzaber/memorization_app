import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('ManageDeckCubit', () {
    late DeckRepository deckRepository;
    late CsvRepository csvRepository;
    late ManageDeckCubit manageDeckCubit;

    setUp(() {
      deckRepository = MockDeckRepository();
      csvRepository = MockCsvRepository();
      manageDeckCubit = ManageDeckCubit(deckRepository, csvRepository);
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => ManageDeckCubit(deckRepository, csvRepository),
            returnsNormally);
      });

      test('initial state is correct', () {
        final cubit = ManageDeckCubit(deckRepository, csvRepository);
        expect(
            cubit.state,
            const ManageDeckState(
                status: ManageDeckStatus.initial,
                errorMessage: '',
                deckIndex: null,
                deck: Deck(name: '', url: '')));
      });
    });

    group('onNameChanged', () {
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits correct state',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.onNameChanged('name'),
        expect: () => const <ManageDeckState>[
          ManageDeckState(deck: Deck(name: 'name', url: ''))
        ],
      );
    });

    group('onUrlChanged', () {
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits correct state',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.onUrlChanged('url'),
        expect: () => const <ManageDeckState>[
          ManageDeckState(deck: Deck(name: '', url: 'url'))
        ],
      );
    });

    group('onColorChanged', () {
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits correct state',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.onColorChanged(0xffffffff),
        expect: () => const <ManageDeckState>[
          ManageDeckState(deck: Deck(name: '', url: '', color: 0xffffffff))
        ],
      );
    });

    group('onEntriesChanged', () {
      final entry = Entry(title: 'title', description: 'description');
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits correct state',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.onEntriesChanged([entry]),
        expect: () => <ManageDeckState>[
          ManageDeckState(deck: Deck(name: '', url: '', entries: [entry]))
        ],
      );
    });

    group('readDeck', () {
      Deck deck = const Deck(name: 'name', url: 'url');

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, initial] if index provided',
        setUp: () {
          when(() => deckRepository.readDeck(any())).thenAnswer((_) => deck);
        },
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(index: 2),
        expect: () => <ManageDeckState>[
          const ManageDeckState(status: ManageDeckStatus.loading),
          ManageDeckState(
              status: ManageDeckStatus.initial, deckIndex: 2, deck: deck),
        ],
        verify: (_) {
          verify(() => deckRepository.readDeck(2)).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits current state if index not provided',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(),
        expect: () => <ManageDeckState>[
          const ManageDeckState(),
        ],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, failure] when throws exception',
        setUp: () {
          when(() => deckRepository.readDeck(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => manageDeckCubit,
        act: (cubit) => cubit.readDeck(index: 2),
        expect: () => <ManageDeckState>[
          const ManageDeckState(status: ManageDeckStatus.loading),
          const ManageDeckState(
              status: ManageDeckStatus.failure,
              errorMessage: 'Exception: failure'),
        ],
        verify: (_) {
          verify(() => deckRepository.readDeck(2)).called(1);
        },
      );
    });

    group('createDeck', () {
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [failure] when deck name is empty',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.createDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(status: ManageDeckStatus.loading),
          ManageDeckState(
              status: ManageDeckStatus.failure, errorMessage: 'Empty name')
        ],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, success] when successful',
        setUp: () {
          when(() => deckRepository.createDeck(any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deck: Deck(name: 'name', url: 'url')),
        act: (cubit) => cubit.createDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(
              status: ManageDeckStatus.loading,
              deck: Deck(name: 'name', url: 'url')),
          ManageDeckState(
              status: ManageDeckStatus.success,
              deck: Deck(name: 'name', url: 'url'))
        ],
        verify: (_) {
          verify(() => deckRepository
              .createDeck(const Deck(name: 'name', url: 'url'))).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, failure] when error occurs',
        setUp: () {
          when(() => deckRepository.createDeck(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deck: Deck(name: 'name', url: 'url')),
        act: (cubit) => cubit.createDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(
              status: ManageDeckStatus.loading,
              deck: Deck(name: 'name', url: 'url')),
          ManageDeckState(
              status: ManageDeckStatus.failure,
              errorMessage: 'Exception: failure',
              deck: Deck(name: 'name', url: 'url'))
        ],
        verify: (_) {
          verify(() => deckRepository
              .createDeck(const Deck(name: 'name', url: 'url'))).called(1);
        },
      );
    });

    group('updateDeck', () {
      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [failure] when deck name is empty',
        build: () => manageDeckCubit,
        act: (cubit) => cubit.updateDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(status: ManageDeckStatus.loading),
          ManageDeckState(
              status: ManageDeckStatus.failure, errorMessage: 'Empty name')
        ],
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, success] when successful',
        setUp: () {
          when(() => deckRepository.updateDeck(any(), any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(
            deck: Deck(name: 'name', url: 'url'), deckIndex: 2),
        act: (cubit) => cubit.updateDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(
              status: ManageDeckStatus.loading,
              deck: Deck(name: 'name', url: 'url'),
              deckIndex: 2),
          ManageDeckState(
              status: ManageDeckStatus.success,
              deck: Deck(name: 'name', url: 'url'),
              deckIndex: 2)
        ],
        verify: (_) {
          verify(() => deckRepository.updateDeck(
              2, const Deck(name: 'name', url: 'url'))).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [loading, failure] when error occurs',
        setUp: () {
          when(() => deckRepository.updateDeck(any(), any()))
              .thenThrow(Exception('failure'));
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(
            deck: Deck(name: 'name', url: 'url'), deckIndex: 2),
        act: (cubit) => cubit.updateDeck(),
        expect: () => const <ManageDeckState>[
          ManageDeckState(
              status: ManageDeckStatus.loading,
              deck: Deck(name: 'name', url: 'url'),
              deckIndex: 2),
          ManageDeckState(
              status: ManageDeckStatus.failure,
              errorMessage: 'Exception: failure',
              deck: Deck(name: 'name', url: 'url'),
              deckIndex: 2)
        ],
        verify: (_) {
          verify(() => deckRepository.updateDeck(
              2, const Deck(name: 'name', url: 'url'))).called(1);
        },
      );
    });

    group('readCsv', () {
      final entries = [Entry(title: 'title', description: 'description')];

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [csvLoading, csvSuccess] when successful',
        setUp: () {
          when(() => csvRepository.readCsv(any()))
              .thenAnswer((_) async => entries);
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deck: Deck(name: 'name', url: 'url')),
        act: (cubit) => cubit.readCsv(),
        expect: () => <ManageDeckState>[
          const ManageDeckState(
              status: ManageDeckStatus.csvLoading,
              deck: Deck(name: 'name', url: 'url')),
          ManageDeckState(
              status: ManageDeckStatus.csvSuccess,
              deck: Deck(name: 'name', url: 'url', entries: entries))
        ],
        verify: (_) {
          verify(() => csvRepository.readCsv('url')).called(1);
        },
      );

      blocTest<ManageDeckCubit, ManageDeckState>(
        'emits [csvLoading, csvFailure] when failure',
        setUp: () {
          when(() => csvRepository.readCsv(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => manageDeckCubit,
        seed: () => const ManageDeckState(deck: Deck(name: 'name', url: 'url')),
        act: (cubit) => cubit.readCsv(),
        expect: () => <ManageDeckState>[
          const ManageDeckState(
              status: ManageDeckStatus.csvLoading,
              deck: Deck(name: 'name', url: 'url')),
          const ManageDeckState(
              status: ManageDeckStatus.csvFailure,
              errorMessage: 'Exception: failure',
              deck: Deck(name: 'name', url: 'url'))
        ],
        verify: (_) {
          verify(() => csvRepository.readCsv('url')).called(1);
        },
      );
    });
  });
}
