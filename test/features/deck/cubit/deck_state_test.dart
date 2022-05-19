import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('DeckState', () {
    group('constructor', () {
      test('works properly', () {
        expect(() => const DeckState(), returnsNormally);
      });

      test('creates object with parameters default values', () {
        DeckState state = const DeckState();

        expect(state.status, DeckStatus.loading);
        expect(state.deckIndex, null);
        expect(state.deck, const Deck(name: '', url: ''));
        expect(state.errorMessage, '');
      });

      test('sets parameters if provided', () {
        Deck deck = const Deck(name: 'name', url: 'url');
        DeckState state = DeckState(
          status: DeckStatus.failure,
          deckIndex: 2,
          deck: deck,
          errorMessage: 'error',
        );

        expect(state.status, DeckStatus.failure);
        expect(state.deckIndex, 2);
        expect(state.deck, const Deck(name: 'name', url: 'url'));
        expect(state.errorMessage, 'error');
      });

      test('supports value equality', () {
        Deck deck = const Deck(name: 'name', url: 'url');
        DeckState state = DeckState(
          status: DeckStatus.failure,
          deckIndex: 2,
          deck: deck,
          errorMessage: 'error',
        );
        expect(
            state,
            DeckState(
              status: DeckStatus.failure,
              deckIndex: 2,
              deck: deck,
              errorMessage: 'error',
            ));
      });

      test('props are correct', () {
        Deck deck = const Deck(name: 'name', url: 'url');
        DeckState state = DeckState(
          status: DeckStatus.failure,
          deckIndex: 2,
          deck: deck,
          errorMessage: 'error',
        );
        expect(
          state.props,
          equals([DeckStatus.failure, 2, deck, 'error']),
        );
      });
    });

    group('copyWith', () {
      Deck deck = const Deck(name: 'name', url: 'url');
      DeckState state = DeckState(
        status: DeckStatus.failure,
        deckIndex: 2,
        deck: deck,
        errorMessage: 'error',
      );
      test('returns the same object if no parameters are provided', () {
        expect(state.copyWith(), state);
      });

      test('replaces every non null parameter', () {
        expect(
          state.copyWith(
            status: DeckStatus.loadSuccess,
            deckIndex: 3,
            deck: const Deck(name: 'newName', url: 'newUrl'),
            errorMessage: '',
          ),
          const DeckState(
            status: DeckStatus.loadSuccess,
            deckIndex: 3,
            deck: Deck(name: 'newName', url: 'newUrl'),
            errorMessage: '',
          ),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
            state.copyWith(
              status: null,
              deckIndex: null,
              deck: null,
              errorMessage: null,
            ),
            state);
      });
    });
  });
}
