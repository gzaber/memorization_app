import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/repositories/deck/deck_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckDataSource extends Mock implements DeckDataSource {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('DeckRepository', () {
    late DeckDataSource mockDataSource;
    late DeckRepository repository;
    Deck deck = const Deck(name: 'name', url: 'url');

    setUp(() {
      mockDataSource = MockDeckDataSource();
      repository = DeckRepository(mockDataSource);
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => DeckRepository(mockDataSource), returnsNormally);
      });
    });

    group('createDeck', () {
      test('creates new deck', () {
        when(() => mockDataSource.createDeck(any()))
            .thenAnswer((_) async => Future.value);

        expect(repository.createDeck(deck), completes);
        verify(() => mockDataSource.createDeck(deck)).called(1);
      });
    });

    group('updateDeck', () {
      test('updates existing deck', () {
        when(() => mockDataSource.updateDeck(any(), any()))
            .thenAnswer((_) async => Future.value);

        expect(repository.updateDeck(0, deck), completes);
        verify(() => mockDataSource.updateDeck(0, deck)).called(1);
      });
    });

    group('deleteDeck', () {
      test('deletes existing deck', () {
        when(() => mockDataSource.deleteDeck(any()))
            .thenAnswer((_) async => Future.value);

        expect(repository.deleteDeck(0), completes);
        verify(() => mockDataSource.deleteDeck(0)).called(1);
      });
    });

    group('readDeck', () {
      test('reads existing deck', () {
        when(() => mockDataSource.readDeck(any())).thenAnswer((_) => deck);

        expect(repository.readDeck(0), deck);
        verify(() => mockDataSource.readDeck(0)).called(1);
      });

      test('throws Exception when deck not found', () {
        when(() => mockDataSource.readDeck(any())).thenAnswer((_) => null);

        expect(() => repository.readDeck(0), throwsA(isA<Exception>()));
        verify(() => mockDataSource.readDeck(0)).called(1);
      });
    });

    group('readAllDecks', () {
      test('reads all existing decks', () {
        when(() => mockDataSource.readAllDecks()).thenAnswer((_) => [deck]);

        expect(repository.readAllDecks(), [deck]);
        verify(() => mockDataSource.readAllDecks()).called(1);
      });

      test('returns empty list when no deck exists', () {
        when(() => mockDataSource.readAllDecks()).thenAnswer((_) => []);

        expect(repository.readAllDecks(), []);
        verify(() => mockDataSource.readAllDecks()).called(1);
      });
    });
  });
}
