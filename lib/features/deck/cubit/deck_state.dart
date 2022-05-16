part of 'deck_cubit.dart';

enum DeckStatus {
  loading,
  loadSuccess,
  deleteSuccess,
  failure,
}

class DeckState extends Equatable {
  final DeckStatus status;
  final int? deckIndex;
  final Deck deck;
  final String errorMessage;

  const DeckState({
    this.status = DeckStatus.loading,
    this.deckIndex,
    this.deck = const Deck(name: '', url: ''),
    this.errorMessage = '',
  });

  DeckState copyWith({
    DeckStatus? status,
    int? deckIndex,
    Deck? deck,
    String? errorMessage,
  }) {
    return DeckState(
      status: status ?? this.status,
      deckIndex: deckIndex ?? this.deckIndex,
      deck: deck ?? this.deck,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, deckIndex, deck, errorMessage];
}
