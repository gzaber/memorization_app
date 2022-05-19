import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data.dart';
import '../../../repositories/repositories.dart';

part 'manage_deck_state.dart';

class ManageDeckCubit extends Cubit<ManageDeckState> {
  final DeckRepository _deckRepository;
  final CsvRepository _csvRepository;

  ManageDeckCubit(this._deckRepository, this._csvRepository)
      : super(const ManageDeckState());

  void onNameChanged(String name) {
    final deck = state.deck.copyWith(name: name);
    emit(state.copyWith(deck: deck, status: ManageDeckStatus.initial));
  }

  void onUrlChanged(String csvUrl) {
    final deck = state.deck.copyWith(url: csvUrl);
    emit(state.copyWith(deck: deck, status: ManageDeckStatus.initial));
  }

  void onColorChanged(int color) {
    final deck = state.deck.copyWith(color: color);
    emit(state.copyWith(deck: deck, status: ManageDeckStatus.initial));
  }

  void onEntriesChanged(List<Entry> entries) {
    final deck = state.deck.copyWith(entries: entries);
    emit(state.copyWith(deck: deck, status: ManageDeckStatus.initial));
  }

  void readDeck({int? index}) {
    if (index == null) {
      emit(state);
    } else {
      emit(state.copyWith(status: ManageDeckStatus.loading));
      try {
        final deck = _deckRepository.readDeck(index);
        emit(state.copyWith(
          status: ManageDeckStatus.initial,
          deck: deck,
          deckIndex: index,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ManageDeckStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> createDeck() async {
    emit(
      state.copyWith(status: ManageDeckStatus.loading),
    );
    if (state.deck.name.trim().isEmpty) {
      emit(state.copyWith(
        status: ManageDeckStatus.failure,
        errorMessage: 'Empty name',
      ));
      return;
    }

    try {
      await _deckRepository.createDeck(state.deck);
      emit(state.copyWith(status: ManageDeckStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ManageDeckStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateDeck() async {
    emit(state.copyWith(status: ManageDeckStatus.loading));
    if (state.deck.name.trim().isEmpty) {
      emit(state.copyWith(
          status: ManageDeckStatus.failure, errorMessage: 'Empty name'));
      return;
    }

    try {
      await _deckRepository.updateDeck(state.deckIndex!, state.deck);
      emit(state.copyWith(status: ManageDeckStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ManageDeckStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> readCsv() async {
    emit(state.copyWith(status: ManageDeckStatus.csvLoading));
    try {
      final entries = await _csvRepository.readCsv(state.deck.url);
      final deck = state.deck.copyWith(entries: entries);
      emit(
        state.copyWith(
          status: ManageDeckStatus.csvSuccess,
          deck: deck,
        ),
      );
    } catch (e) {
      final deck = state.deck.copyWith(entries: []);
      emit(
        state.copyWith(
          status: ManageDeckStatus.csvFailure,
          errorMessage: e.toString(),
          deck: deck,
        ),
      );
    }
  }
}
