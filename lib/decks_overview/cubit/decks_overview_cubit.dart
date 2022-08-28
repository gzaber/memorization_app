import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'decks_overview_state.dart';

class DecksOverviewCubit extends Cubit<DecksOverviewState> {
  DecksOverviewCubit() : super(DecksOverviewInitial());
}
