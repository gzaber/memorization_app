import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data.dart';
import '../../../repositories/repositories.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  final DeckRepository _deckRepository;

  DeckCubit(this._deckRepository) : super(const DeckState());

  void readDeck(int index) {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      final deck = _deckRepository.readDeck(index);
      emit(
        state.copyWith(
            status: DeckStatus.loadSuccess, deckIndex: index, deck: deck),
      );
    } catch (e) {
      emit(state.copyWith(
        status: DeckStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void onLayoutChanged(EntryLayout layout) async {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      final deck = state.deck.copyWith(entryLayout: layout);
      await _deckRepository.updateDeck(state.deckIndex!, deck);
      emit(state.copyWith(status: DeckStatus.loadSuccess, deck: deck));
    } catch (e) {
      emit(state.copyWith(
        status: DeckStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void deleteDeck() async {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      await _deckRepository.deleteDeck(state.deckIndex!);
      emit(
        state.copyWith(status: DeckStatus.deleteSuccess),
      );
    } catch (e) {
      emit(state.copyWith(
        status: DeckStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
