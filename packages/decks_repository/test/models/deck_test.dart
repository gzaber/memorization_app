import 'package:decks_repository/decks_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    final name = 'name';

    group('constructor', () {
      test('works properly', () {
        expect(() => Deck(name: name), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(Deck(name: name), equals(Deck(name: name)));
    });

    test('props are correct', () {
      expect(
        Deck(name: name).props,
        equals([name, '', 0xffff8a80, [], EntryLayout.horizontal]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          Deck(name: name).copyWith(),
          equals(Deck(name: name)),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          Deck(name: name).copyWith(
              name: null,
              url: null,
              color: null,
              entries: null,
              entryLayout: null),
          equals(Deck(name: name)),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          Deck(name: name).copyWith(
            name: 'deckName',
            url: 'url',
            color: 0xdddd8b40,
            entries: [Entry(title: 'title', content: 'content')],
            entryLayout: EntryLayout.expansion,
          ),
          equals(
            Deck(
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
    final title = 'title';
    final content = 'content';
    group('constructor', () {
      test('works properly', () {
        expect(
          () => Entry(title: title, content: content),
          returnsNormally,
        );
      });
    });

    test('supports value equality', () {
      expect(
        Entry(title: title, content: content),
        equals(Entry(title: title, content: content)),
      );
    });

    test('props are correct', () {
      expect(
        Entry(title: title, content: content).props,
        equals(['title', 'content']),
      );
    });
  });
}
