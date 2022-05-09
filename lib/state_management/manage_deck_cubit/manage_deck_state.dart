part of 'manage_deck_cubit.dart';

abstract class ManageDeckState extends Equatable {
  const ManageDeckState();

  @override
  List<Object> get props => [];
}

class ManageDeckInitial extends ManageDeckState {}

class ManageDeckLoading extends ManageDeckState {}

class ManageDeckSuccess extends ManageDeckState {}

class ManageDeckFailure extends ManageDeckState {
  final String message;

  const ManageDeckFailure(this.message);

  @override
  List<Object> get props => [message];
}
