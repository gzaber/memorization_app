import 'package:bloc/bloc.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:equatable/equatable.dart';

part 'manage_deck_state.dart';

class ManageDeckCubit extends Cubit<ManageDeckState> {
  ManageDeckCubit({
    required CsvRepository csvRepository,
    required DecksRepository decksRepository,
  })  : _csvRepository = csvRepository,
        _decksRepository = decksRepository,
        super(const ManageDeckState());

  final CsvRepository _csvRepository;
  final DecksRepository _decksRepository;

  void onNameChanged(String name) {
    final deck = state.deck.copyWith(name: name);
    emit(state.copyWith(status: ManageDeckStatus.initial, deck: deck));
  }

  void onUrlChanged(String csvUrl) {
    final deck = state.deck.copyWith(url: csvUrl);
    emit(state.copyWith(status: ManageDeckStatus.initial, deck: deck));
  }

  void onColorChanged(int color) {
    final deck = state.deck.copyWith(color: color);
    emit(state.copyWith(status: ManageDeckStatus.initial, deck: deck));
  }

  void onEntriesChanged(List<Entry> entries) {
    final deck = state.deck.copyWith(entries: entries);
    emit(state.copyWith(status: ManageDeckStatus.initial, deck: deck));
  }

  void readDeck({int? index}) {
    if (index == null) {
      emit(state);
    } else {
      emit(state.copyWith(status: ManageDeckStatus.loading));
      try {
        final deck = _decksRepository.read(index);
        emit(state.copyWith(
          status: ManageDeckStatus.initial,
          deckIndex: index,
          deck: deck,
        ));
      } on Exception {
        emit(state.copyWith(status: ManageDeckStatus.failure));
      }
    }
  }

  Future<void> createDeck() async {
    if (state.deck.name.trim().isEmpty) {
      emit(state.copyWith(status: ManageDeckStatus.emptyName));
      return;
    }
    emit(state.copyWith(status: ManageDeckStatus.loading));
    try {
      await _decksRepository.create(state.deck);
      emit(state.copyWith(status: ManageDeckStatus.saveSuccess));
    } on Exception {
      emit(state.copyWith(status: ManageDeckStatus.failure));
    }
  }

  Future<void> updateDeck() async {
    if (state.deck.name.trim().isEmpty) {
      emit(state.copyWith(status: ManageDeckStatus.emptyName));
      return;
    }
    emit(state.copyWith(status: ManageDeckStatus.loading));
    try {
      await _decksRepository.update(state.deckIndex!, state.deck);
      emit(state.copyWith(status: ManageDeckStatus.saveSuccess));
    } on Exception {
      emit(state.copyWith(status: ManageDeckStatus.failure));
    }
  }

  Future<void> readCsv() async {
    emit(state.copyWith(status: ManageDeckStatus.csvLoading));
    try {
      final fetchedData = await _csvRepository.fetchData(state.deck.url);
      final entries = fetchedData
          .map((row) => Entry(title: row[0], content: row[1]))
          .toList();
      final deck = state.deck.copyWith(entries: entries);
      emit(
        state.copyWith(status: ManageDeckStatus.csvSuccess, deck: deck),
      );
    } on Exception {
      final deck = state.deck.copyWith(entries: []);
      emit(
        state.copyWith(status: ManageDeckStatus.csvFailure, deck: deck),
      );
    }
  }
}
