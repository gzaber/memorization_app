import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data.dart';
import '../../repositories/repositories.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<Settings> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(const Settings());

  void readSettings() async {
    try {
      final settings = _settingsRepository.readSettings();
      if (settings != null) {
        emit(settings);
      } else {
        await _settingsRepository.createSettings();
        emit(state);
      }
    } catch (e) {
      emit(state);
    }
  }

  void updateSettings(Settings settings) async {
    try {
      await _settingsRepository.updateSettings(settings);
      emit(settings);
    } catch (e) {
      emit(state);
    }
  }
}
