import 'package:hive_flutter/hive_flutter.dart';

import '../../models/deck.dart';
import '../data_sources.dart';

class HiveDeckDataSource extends DeckDataSource {
  final Box<Deck> _box;

  HiveDeckDataSource._(this._box);

  static Future<HiveDeckDataSource> create(HiveInterface hive) async {
    hive.registerAdapter(DeckAdapter());
    hive.registerAdapter(EntryAdapter());
    hive.registerAdapter(EntryLayoutAdapter());
    final box = await hive.openBox<Deck>('decks');
    return HiveDeckDataSource._(box);
  }

  @override
  Future<void> createDeck(Deck deck) async {
    await _box.add(deck);
  }

  @override
  Future<void> updateDeck(int index, Deck deck) async {
    await _box.putAt(index, deck);
  }

  @override
  Future<void> deleteDeck(int index) async {
    await _box.deleteAt(index);
  }

  @override
  Deck? readDeck(int index) {
    return _box.getAt(index);
  }

  @override
  List<Deck> readAllDecks() {
    if (_box.isEmpty) {
      return [];
    } else {
      return _box.values.toList();
    }
  }
}
