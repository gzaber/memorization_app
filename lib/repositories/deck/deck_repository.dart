import '../../data/data.dart';

class DeckRepository {
  final DeckDataSource _dataSource;

  DeckRepository(this._dataSource);

  Future<void> createDeck(Deck deck) async =>
      await _dataSource.createDeck(deck);

  Future<void> updateDeck(int index, Deck deck) async =>
      await _dataSource.updateDeck(index, deck);

  Future<void> deleteDeck(int index) async =>
      await _dataSource.deleteDeck(index);

  Deck readDeck(int index) => _dataSource.readDeck(index);

  List<Deck> readAllDecks() => _dataSource.readAllDecks();
}
