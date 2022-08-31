import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/deck/deck.dart';

void main() {
  group('DeckState', () {
    DeckState createState({
      DeckStatus status = DeckStatus.loading,
      int deckIndex = 0,
      Deck deck = const Deck(name: 'name'),
    }) =>
        DeckState(status: status, deckIndex: deckIndex, deck: deck);

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([DeckStatus.loading, 0, const Deck(name: 'name')]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(status: null, deckIndex: null, deck: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
            status: DeckStatus.failure,
            deckIndex: 1,
            deck: const Deck(name: 'name2'),
          ),
          equals(
            createState(
              status: DeckStatus.failure,
              deckIndex: 1,
              deck: const Deck(name: 'name2'),
            ),
          ),
        );
      });
    });
  });
}
