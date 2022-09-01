import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';

void main() {
  group('ManageDeckState', () {
    ManageDeckState createState({
      ManageDeckStatus status = ManageDeckStatus.initial,
      int? deckIndex,
      Deck deck = const Deck(name: ''),
    }) =>
        ManageDeckState(status: status, deckIndex: deckIndex, deck: deck);

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([ManageDeckStatus.initial, null, const Deck(name: '')]),
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
            status: ManageDeckStatus.failure,
            deckIndex: 1,
            deck: const Deck(name: 'name'),
          ),
          equals(
            createState(
              status: ManageDeckStatus.failure,
              deckIndex: 1,
              deck: const Deck(name: 'name'),
            ),
          ),
        );
      });
    });
  });
}
