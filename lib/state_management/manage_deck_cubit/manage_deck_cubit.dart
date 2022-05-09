import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data.dart';
import '../../repositories/repositories.dart';

part 'manage_deck_state.dart';

class ManageDeckCubit extends Cubit<ManageDeckState> {
  final DeckRepository _deckRepository;

  ManageDeckCubit(this._deckRepository) : super(ManageDeckInitial());

  void createDeck(Deck deck) async {
    emit(ManageDeckLoading());
    try {
      await _deckRepository.createDeck(deck);
    } catch (e) {
      emit(ManageDeckFailure(e.toString()));
    }
  }

  void updateDeck(Deck deck) async {
    emit(ManageDeckLoading());
    try {
      await _deckRepository.createDeck(deck);
    } catch (e) {
      emit(ManageDeckFailure(e.toString()));
    }
  }
}
