import 'package:decks_repository/decks_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';

void main() {
  group('DecksOverviewState', () {
    const deck = Deck(name: 'name');

    DecksOverviewState createState({
      DecksOverviewStatus status = DecksOverviewStatus.loading,
      List<Deck> decks = const [],
    }) =>
        DecksOverviewState(status: status, decks: decks);

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([DecksOverviewStatus.loading, []]),
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
          createState().copyWith(status: null, decks: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState()
              .copyWith(status: DecksOverviewStatus.failure, decks: [deck]),
          equals(
              createState(status: DecksOverviewStatus.failure, decks: [deck])),
        );
      });
    });
  });
}
