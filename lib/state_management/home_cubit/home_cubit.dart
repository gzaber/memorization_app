import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data.dart';
import '../../repositories/repositories.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DeckRepository _deckRepository;

  HomeCubit(this._deckRepository) : super(HomeInitial());

  void readAllDecks() {
    emit(HomeLoading());
    try {
      final decks = _deckRepository.readAllDecks();
      emit(HomeSuccess(decks));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

// TODO: move to another cubit
  void deleteDeck(int index) async {
    try {
      await _deckRepository.deleteDeck(index);
      readAllDecks();
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
