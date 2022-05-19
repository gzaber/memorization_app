import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:memorization_app/data/data.dart';
import 'package:mocktail/mocktail.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Deck> {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('HiveDeckDataSource', () {
    late HiveInterface mockHive;
    late Box<Deck> mockBox;
    late HiveDeckDataSource dataSource;
    Deck deck = const Deck(name: 'name', url: 'url');

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    setUp(() async {
      mockHive = MockHive();
      mockBox = MockBox();

      when(() => mockHive.openBox<Deck>(any()))
          .thenAnswer((_) async => mockBox);

      dataSource = await HiveDeckDataSource.create(mockHive);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() async => await HiveDeckDataSource.create(mockHive),
            returnsNormally);
      });
    });

    group('createDeck', () {
      test('creates new deck', () {
        when(() => mockBox.add(any())).thenAnswer((_) async => 0);

        expect(dataSource.createDeck(deck), completes);
        verify(() => mockBox.add(deck)).called(1);
      });
    });

    group('updateDeck', () {
      test('updates existing deck', () {
        when(() => mockBox.putAt(any(), any()))
            .thenAnswer((_) async => Future.value);

        expect(dataSource.updateDeck(0, deck), completes);
        verify(() => mockBox.putAt(0, deck)).called(1);
      });
    });

    group('deleteDeck', () {
      test('deletes existing deck', () {
        when(() => mockBox.deleteAt(any()))
            .thenAnswer((_) async => Future.value);

        expect(dataSource.deleteDeck(0), completes);
        verify(() => mockBox.deleteAt(0)).called(1);
      });
    });

    group('readDeck', () {
      test('reads existing deck', () {
        when(() => mockBox.getAt(any())).thenAnswer((_) => deck);

        expect(dataSource.readDeck(0), deck);
        verify(() => mockBox.getAt(0)).called(1);
      });

      test('returns null when deck not found', () {
        when(() => mockBox.getAt(any())).thenAnswer((_) => null);

        expect(dataSource.readDeck(0), null);
        verify(() => mockBox.getAt(0)).called(1);
      });
    });

    group('readAllDecks', () {
      test('reads all existing decks', () {
        Deck anotherDeck = const Deck(name: 'anotherName', url: 'anotherUrl');
        when(() => mockBox.isEmpty).thenAnswer((_) => false);
        when(() => mockBox.values.toList())
            .thenAnswer((_) => [deck, anotherDeck]);

        expect(dataSource.readAllDecks(), [deck, anotherDeck]);
        verify(() => mockBox.isEmpty).called(1);
        verify(() => mockBox.values.toList()).called(1);
      });

      test('returns empty list when no deck exists', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => true);

        expect(dataSource.readAllDecks(), []);
        verify(() => mockBox.isEmpty).called(1);
      });
    });
  });
}
