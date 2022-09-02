import 'package:bloc/bloc.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:equatable/equatable.dart';

part 'decks_overview_state.dart';

class DecksOverviewCubit extends Cubit<DecksOverviewState> {
  DecksOverviewCubit({required DecksRepository decksRepository})
      : _decksRepository = decksRepository,
        super(const DecksOverviewState());

  final DecksRepository _decksRepository;

  void readAllDecks() {
    emit(state.copyWith(status: DecksOverviewStatus.loading));
    try {
      final decks = _decksRepository.readAll();
      emit(state.copyWith(status: DecksOverviewStatus.success, decks: decks));
    } catch (e) {
      emit(state.copyWith(status: DecksOverviewStatus.failure));
    }
  }
}
