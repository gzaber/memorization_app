part of 'deck_cubit.dart';

abstract class DeckState extends Equatable {
  const DeckState();

  @override
  List<Object> get props => [];
}

class DeckLoading extends DeckState {}

class DeckReadSuccess extends DeckState {
  final Deck deck;

  const DeckReadSuccess(this.deck);

  @override
  List<Object> get props => [deck];
}

class DeckFailure extends DeckState {
  final String message;

  const DeckFailure(this.message);

  @override
  List<Object> get props => [message];
}
