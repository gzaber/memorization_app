import '../models/models.dart';

abstract class DeckDataSource {
  Future<void> createDeck(Deck deck);
  Future<void> updateDeck(int index, Deck deck);
  Future<void> deleteDeck(int index);
  Deck readDeck(int index);
  List<Deck> readAllDecks();
}
