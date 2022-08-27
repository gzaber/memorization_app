import 'package:decks_repository/decks_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    Deck createDeck({
      String name = 'name',
      String url = '',
      int color = 0xffff8a80,
      List<Entry> entries = const [],
      EntryLayout entryLayout = EntryLayout.horizontal,
    }) {
      return Deck(
        name: name,
        url: url,
        color: color,
        entries: entries,
        entryLayout: entryLayout,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createDeck(), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createDeck(), equals(createDeck()));
    });

    test('props are correct', () {
      expect(
        createDeck().props,
        equals(['name', '', 0xffff8a80, [], EntryLayout.horizontal]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createDeck().copyWith(),
          equals(createDeck()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createDeck().copyWith(
              name: null,
              url: null,
              color: null,
              entries: null,
              entryLayout: null),
          equals(createDeck()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createDeck().copyWith(
            name: 'deckName',
            url: 'url',
            color: 0xdddd8b40,
            entries: [Entry(title: 'title', content: 'content')],
            entryLayout: EntryLayout.expansion,
          ),
          equals(
            createDeck(
              name: 'deckName',
              url: 'url',
              color: 0xdddd8b40,
              entries: [Entry(title: 'title', content: 'content')],
              entryLayout: EntryLayout.expansion,
            ),
          ),
        );
      });
    });
  });

  group('Entry', () {
    Entry createEntry() => Entry(title: 'title', content: 'content');
    group('constructor', () {
      test('works properly', () {
        expect(
          () => createEntry(),
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        createEntry(),
        equals(createEntry()),
      );
    });

    test('props are correct', () {
      expect(
        createEntry().props,
        equals(['title', 'content']),
      );
    });
  });
}
