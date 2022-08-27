import 'package:decks_repository/decks_repository.dart';
import 'package:hive/hive.dart';

class DecksRepository {
  final Box<Deck> _box;

  DecksRepository._(this._box);

  static Future<DecksRepository> init(HiveInterface hive) async {
    hive.registerAdapter(DeckAdapter());
    hive.registerAdapter(EntryAdapter());
    hive.registerAdapter(EntryLayoutAdapter());
    final box = await hive.openBox<Deck>('decks');
    return DecksRepository._(box);
  }

  Future<void> create(Deck deck) async {
    await _box.add(deck);
  }

  Future<void> update(int index, Deck deck) async {
    await _box.putAt(index, deck);
  }

  Future<void> delete(int index) async {
    await _box.deleteAt(index);
  }

  Deck? read(int index) {
    return _box.getAt(index);
  }

  List<Deck> readAll() {
    if (_box.isEmpty) {
      return [];
    } else {
      return _box.values.toList();
    }
  }
}
