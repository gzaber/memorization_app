import 'package:decks_repository/decks_repository.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Deck> {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('DecksRepository', () {
    late HiveInterface mockHive;
    late Box<Deck> mockBox;
    late DecksRepository decksRepository;
    final deck = Deck(name: 'name');

    setUp(() async {
      mockHive = MockHive();
      mockBox = MockBox();

      when(() => mockHive.openBox<Deck>(any()))
          .thenAnswer((_) async => mockBox);

      decksRepository = await DecksRepository.init(mockHive);
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () async => await DecksRepository.init(mockHive),
          returnsNormally,
        );
      });
    });

    group('create', () {
      test('creates deck', () {
        when(() => mockBox.add(any())).thenAnswer((_) async => 0);

        expect(decksRepository.create(deck), completes);
        verify(() => mockBox.add(deck)).called(1);
      });
    });

    group('update', () {
      test('updates deck', () {
        when(() => mockBox.putAt(any(), any()))
            .thenAnswer((_) async => Future.value);

        expect(decksRepository.update(0, deck), completes);
        verify(() => mockBox.putAt(0, deck)).called(1);
      });
    });

    group('deleteDeck', () {
      test('deletes deck', () {
        when(() => mockBox.deleteAt(any()))
            .thenAnswer((_) async => Future.value);

        expect(decksRepository.delete(0), completes);
        verify(() => mockBox.deleteAt(0)).called(1);
      });
    });

    group('read', () {
      test('reads deck', () {
        when(() => mockBox.getAt(any())).thenAnswer((_) => deck);

        expect(decksRepository.read(0), deck);
        verify(() => mockBox.getAt(0)).called(1);
      });

      test('returns null when deck not found', () {
        when(() => mockBox.getAt(any())).thenAnswer((_) => null);

        expect(decksRepository.read(0), null);
        verify(() => mockBox.getAt(0)).called(1);
      });
    });

    group('readAll', () {
      test('reads all decks', () {
        Deck anotherDeck = const Deck(name: 'anotherName', url: 'anotherUrl');
        when(() => mockBox.isEmpty).thenAnswer((_) => false);
        when(() => mockBox.values.toList())
            .thenAnswer((_) => [deck, anotherDeck]);

        expect(decksRepository.readAll(), [deck, anotherDeck]);
        verify(() => mockBox.isEmpty).called(1);
        verify(() => mockBox.values.toList()).called(1);
      });

      test('returns empty list when no deck found', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => true);

        expect(decksRepository.readAll(), []);
        verify(() => mockBox.isEmpty).called(1);
      });
    });
  });
}
