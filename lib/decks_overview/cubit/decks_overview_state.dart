part of 'decks_overview_cubit.dart';

enum DecksOverviewStatus { loading, success, failure }

class DecksOverviewState extends Equatable {
  const DecksOverviewState({
    this.status = DecksOverviewStatus.loading,
    this.decks = const [],
  });

  final DecksOverviewStatus status;
  final List<Deck> decks;

  @override
  List<Object> get props => [status, decks];

  DecksOverviewState copyWith({
    DecksOverviewStatus? status,
    List<Deck>? decks,
  }) {
    return DecksOverviewState(
      status: status ?? this.status,
      decks: decks ?? this.decks,
    );
  }
}
