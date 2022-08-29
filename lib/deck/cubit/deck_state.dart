part of 'deck_cubit.dart';

enum DeckStatus {
  loading,
  loadSuccess,
  deleteSuccess,
  failure,
}

class DeckState extends Equatable {
  const DeckState({
    this.status = DeckStatus.loading,
    required this.deckIndex,
    this.deck = const Deck(name: ''),
  });

  final DeckStatus status;
  final int deckIndex;
  final Deck deck;

  @override
  List<Object> get props => [status, deckIndex, deck];

  DeckState copyWith({
    DeckStatus? status,
    int? deckIndex,
    Deck? deck,
  }) {
    return DeckState(
      status: status ?? this.status,
      deckIndex: deckIndex ?? this.deckIndex,
      deck: deck ?? this.deck,
    );
  }
}
