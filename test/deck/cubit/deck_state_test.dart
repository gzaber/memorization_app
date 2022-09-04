import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/deck/deck.dart';

void main() {
  group('DeckState', () {
    const deckIndex = 0;

    test('constructor works properly', () {
      expect(() => const DeckState(deckIndex: deckIndex), returnsNormally);
    });

    test('supports value equality', () {
      expect(
        const DeckState(deckIndex: deckIndex),
        equals(const DeckState(deckIndex: deckIndex)),
      );
    });

    test('props are correct', () {
      const deck = Deck(name: 'name');
      expect(
        const DeckState(deckIndex: deckIndex, deck: deck).props,
        equals([DeckStatus.loading, deckIndex, deck]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          const DeckState(deckIndex: deckIndex).copyWith(),
          equals(const DeckState(deckIndex: deckIndex)),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          const DeckState(deckIndex: deckIndex)
              .copyWith(status: null, deckIndex: null, deck: null),
          equals(const DeckState(deckIndex: deckIndex)),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          const DeckState(deckIndex: deckIndex).copyWith(
            status: DeckStatus.failure,
            deckIndex: 1,
            deck: const Deck(name: 'name2'),
          ),
          equals(
            const DeckState(
              status: DeckStatus.failure,
              deckIndex: 1,
              deck: Deck(name: 'name2'),
            ),
          ),
        );
      });
    });
  });
}
