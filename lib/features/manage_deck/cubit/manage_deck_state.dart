part of 'manage_deck_cubit.dart';

enum ManageDeckStatus {
  initial,
  loading,
  success,
  failure,
  csvLoading,
  csvSuccess,
  csvFailure,
}

class ManageDeckState extends Equatable {
  final ManageDeckStatus status;
  final String errorMessage;
  final int? deckIndex;
  final Deck deck;

  const ManageDeckState({
    this.status = ManageDeckStatus.initial,
    this.errorMessage = '',
    this.deckIndex,
    this.deck = const Deck(name: '', url: ''),
  });

  ManageDeckState copyWith({
    ManageDeckStatus? status,
    String? errorMessage,
    int? deckIndex,
    Deck? deck,
  }) {
    return ManageDeckState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        deckIndex: deckIndex ?? this.deckIndex,
        deck: deck ?? this.deck);
  }

  @override
  List<Object?> get props => [status, errorMessage, deckIndex, deck];
}
