import 'package:bloc_test/bloc_test.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/decks_overview/cubit/decks_overview_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockDecksRepository extends Mock implements DecksRepository {}

void main() {
  group('DecksOverviewCubit', () {
    late DecksRepository decksRepository;

    setUp(() {
      decksRepository = MockDecksRepository();
    });

    DecksOverviewCubit createCubit() =>
        DecksOverviewCubit(decksRepository: decksRepository);

    group('constructor', () {
      test('works properly', () {
        expect(() => createCubit(), returnsNormally);
      });

      test('initial state is correct', () {
        expect(createCubit().state, equals(const DecksOverviewState()));
      });
    });

    group('readAllDecks', () {
      const deck = Deck(name: 'name');

      blocTest<DecksOverviewCubit, DecksOverviewState>(
        'emits state with success status and list of decks',
        setUp: () {
          when(() => decksRepository.readAll()).thenAnswer((_) => [deck]);
        },
        build: () => createCubit(),
        act: (cubit) => cubit.readAllDecks(),
        expect: () => [
          const DecksOverviewState(status: DecksOverviewStatus.loading),
          const DecksOverviewState(
              status: DecksOverviewStatus.success, decks: [deck]),
        ],
        verify: (_) {
          verify(() => decksRepository.readAll()).called(1);
        },
      );

      blocTest<DecksOverviewCubit, DecksOverviewState>(
        'emits state with failure status when exception occured',
        setUp: () {
          when(() => decksRepository.readAll()).thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.readAllDecks(),
        expect: () => [
          const DecksOverviewState(status: DecksOverviewStatus.loading),
          const DecksOverviewState(status: DecksOverviewStatus.failure),
        ],
        verify: (_) {
          verify(() => decksRepository.readAll()).called(1);
        },
      );
    });
  });
}
