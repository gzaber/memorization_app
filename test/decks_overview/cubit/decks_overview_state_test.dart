import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';

void main() {
  group('DecksOverviewState', () {
    test('constructor works properly', () {
      expect(() => const DecksOverviewState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(const DecksOverviewState(), equals(const DecksOverviewState()));
    });

    test('props are correct', () {
      expect(
        const DecksOverviewState().props,
        equals([DecksOverviewStatus.loading, []]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          const DecksOverviewState().copyWith(),
          equals(const DecksOverviewState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          const DecksOverviewState().copyWith(status: null, decks: null),
          equals(const DecksOverviewState()),
        );
      });

      test('replaces non-null parameters', () {
        const deck = Deck(name: 'name');
        expect(
          const DecksOverviewState()
              .copyWith(status: DecksOverviewStatus.failure, decks: [deck]),
          equals(const DecksOverviewState(
              status: DecksOverviewStatus.failure, decks: [deck])),
        );
      });
    });
  });
}
