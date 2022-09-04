import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';

void main() {
  group('ManageDeckState', () {
    test('constructor works properly', () {
      expect(() => const ManageDeckState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(const ManageDeckState(), equals(const ManageDeckState()));
    });

    test('props are correct', () {
      expect(
        const ManageDeckState().props,
        equals([ManageDeckStatus.initial, null, const Deck(name: '')]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          const ManageDeckState().copyWith(),
          equals(const ManageDeckState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          const ManageDeckState()
              .copyWith(status: null, deckIndex: null, deck: null),
          equals(const ManageDeckState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          const ManageDeckState().copyWith(
            status: ManageDeckStatus.failure,
            deckIndex: 1,
            deck: const Deck(name: 'name'),
          ),
          equals(
            const ManageDeckState(
              status: ManageDeckStatus.failure,
              deckIndex: 1,
              deck: Deck(name: 'name'),
            ),
          ),
        );
      });
    });
  });
}
