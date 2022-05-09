import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data.dart';
import '../../repositories/repositories.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  final DeckRepository _deckRepository;

  DeckCubit(this._deckRepository) : super(DeckLoading());

  void readDeck(int index) {
    emit(DeckLoading());
    try {
      final deck = _deckRepository.readDeck(index);
      emit(DeckReadSuccess(deck));
    } catch (e) {
      emit(DeckFailure(e.toString()));
    }
  }

  void updateEntryLayout(int index, EntryLayout entryLayout) async {
    emit(DeckLoading());
    try {
      final deck = _deckRepository.readDeck(index);
      final updatedDeck = deck.copyWith(entryLayout: entryLayout);
      await _deckRepository.updateDeck(index, updatedDeck);
      readDeck(index);
    } catch (e) {
      emit(DeckFailure(e.toString()));
    }
  }
}
