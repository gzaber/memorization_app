import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';

void main() {
  group('Deck', () {
    group('constructor', () {
      test('works correctly', () {
        expect(() => const Deck(name: 'name', url: 'url'), returnsNormally);
      });

      test(
          'creates object with required parameters '
          'and default optional parameters', () {
        Deck deck = const Deck(name: 'name', url: 'url');

        expect(deck.name, 'name');
        expect(deck.url, 'url');
        expect(deck.color, 0xffff8a80);
        expect(deck.entries, []);
        expect(deck.entryLayout, EntryLayout.row);
      });

      test('sets optional parameters if provided', () {
        List<Entry> entries = [
          Entry(title: 'title', description: 'description')
        ];
        Deck deck = Deck(
          name: 'name',
          url: 'url',
          color: 0xff000000,
          entries: entries,
          entryLayout: EntryLayout.expansionTile,
        );

        expect(deck.name, 'name');
        expect(deck.url, 'url');
        expect(deck.color, 0xff000000);
        expect(deck.entries, entries);
        expect(deck.entryLayout, EntryLayout.expansionTile);
      });

      test('supports value equality', () {
        Deck deck = const Deck(name: 'name', url: 'url');
        expect(deck, const Deck(name: 'name', url: 'url'));
      });

      test('props are correct', () {
        Deck deck = const Deck(name: 'name', url: 'url');
        expect(
            deck.props,
            equals([
              'name',
              'url',
              0xffff8a80,
              [],
              EntryLayout.row,
            ]));
      });
    });

    group('copyWith', () {
      List<Entry> entries = [Entry(title: 'title', description: 'description')];
      final deck = Deck(
        name: 'name',
        url: 'url',
        color: 0xffffffff,
        entries: entries,
        entryLayout: EntryLayout.expansionTile,
      );
      test('returns the same object if no parameters are provided', () {
        expect(deck.copyWith(), deck);
      });

      test('replaces every non null parameter', () {
        expect(
            deck.copyWith(
              name: 'copyName',
              url: 'copyUrl',
              color: 0xff123456,
              entries: entries,
              entryLayout: EntryLayout.row,
            ),
            Deck(
              name: 'copyName',
              url: 'copyUrl',
              color: 0xff123456,
              entries: entries,
              entryLayout: EntryLayout.row,
            ));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          deck.copyWith(
            name: null,
            url: null,
            color: null,
            entries: null,
            entryLayout: null,
          ),
          deck,
        );
      });
    });
  });
}
