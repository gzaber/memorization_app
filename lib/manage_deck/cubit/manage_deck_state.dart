part of 'manage_deck_cubit.dart';

enum ManageDeckStatus {
  initial,
  loading,
  failure,
  emptyName,
  saveSuccess,
  csvLoading,
  csvFailure,
}

class ManageDeckState extends Equatable {
  const ManageDeckState({
    this.status = ManageDeckStatus.initial,
    this.deckIndex,
    this.deck = const Deck(name: ''),
  });

  final ManageDeckStatus status;
  final int? deckIndex;
  final Deck deck;

  @override
  List<Object?> get props => [status, deckIndex, deck];

  ManageDeckState copyWith({
    ManageDeckStatus? status,
    int? deckIndex,
    Deck? deck,
  }) {
    return ManageDeckState(
      status: status ?? this.status,
      deckIndex: deckIndex ?? this.deckIndex,
      deck: deck ?? this.deck,
    );
  }
}
