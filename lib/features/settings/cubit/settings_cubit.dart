import 'package:bloc/bloc.dart';

import '../../../data/data.dart';
import '../../../repositories/repositories.dart';

class SettingsCubit extends Cubit<Settings> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(const Settings());

  Future<void> readSettings() async {
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

  Future<void> updateAppTheme(AppTheme appTheme) async {
    try {
      final settings = state.copyWith(appTheme: appTheme);
      await _settingsRepository.updateSettings(settings);
      emit(settings);
    } catch (e) {
      emit(state);
    }
  }

  Future<void> updateAppFontSize(AppFontSize appFontSize) async {
    try {
      final settings = state.copyWith(appFontSize: appFontSize);
      await _settingsRepository.updateSettings(settings);
      emit(settings);
    } catch (e) {
      emit(state);
    }
  }
}
