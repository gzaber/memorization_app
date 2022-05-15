import '../../data/data.dart';

class DeckRepository {
  final DeckDataSource _dataSource;

  DeckRepository(this._dataSource);

  Future<void> createDeck(Deck deck) => _dataSource.createDeck(deck);

  Future<void> updateDeck(int index, Deck deck) =>
      _dataSource.updateDeck(index, deck);

  Future<void> deleteDeck(int index) => _dataSource.deleteDeck(index);

  Deck readDeck(int index) => _dataSource.readDeck(index);

  List<Deck> readAllDecks() => _dataSource.readAllDecks();
}
