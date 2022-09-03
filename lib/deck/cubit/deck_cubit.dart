import 'package:bloc/bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:equatable/equatable.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  DeckCubit({
    required DecksRepository decksRepository,
    required int deckIndex,
  })  : _decksRepository = decksRepository,
        super(DeckState(deckIndex: deckIndex));

  final DecksRepository _decksRepository;

  void readDeck(int index) {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      final deck = _decksRepository.read(index);
      if (deck == null) {
        emit(state.copyWith(status: DeckStatus.failure));
        return;
      }
      emit(state.copyWith(status: DeckStatus.loadSuccess, deck: deck));
    } catch (e) {
      emit(state.copyWith(status: DeckStatus.failure));
    }
  }

  Future<void> onLayoutChanged(EntryLayout layout) async {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      final deck = state.deck.copyWith(entryLayout: layout);
      await _decksRepository.update(state.deckIndex, deck);
      emit(state.copyWith(status: DeckStatus.loadSuccess, deck: deck));
    } catch (e) {
      emit(state.copyWith(status: DeckStatus.failure));
    }
  }

  Future<void> deleteDeck() async {
    emit(state.copyWith(status: DeckStatus.loading));
    try {
      await _decksRepository.delete(state.deckIndex);
      emit(state.copyWith(status: DeckStatus.deleteSuccess));
    } catch (e) {
      emit(state.copyWith(status: DeckStatus.failure));
    }
  }
}
