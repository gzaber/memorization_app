import 'package:bloc/bloc.dart';
import 'package:settings_repository/settings_repository.dart';

class SettingsCubit extends Cubit<Settings> {
  SettingsCubit(this._settingsRepository) : super(const Settings());

  final SettingsRepository _settingsRepository;

  Future<void> readSettings() async {
    try {
      final settings = _settingsRepository.read();
      if (settings != null) {
        emit(settings);
      } else {
        await _settingsRepository.create();
        emit(state);
      }
    } catch (e) {
      emit(state);
    }
  }

  Future<void> updateAppTheme(AppTheme appTheme) async {
    try {
      final settings = state.copyWith(appTheme: appTheme);
      await _settingsRepository.update(settings);
      emit(settings);
    } catch (e) {
      emit(state);
    }
  }

  Future<void> updateAppFontSize(AppFontSize appFontSize) async {
    try {
      final settings = state.copyWith(appFontSize: appFontSize);
      await _settingsRepository.update(settings);
      emit(settings);
    } catch (e) {
      emit(state);
    }
  }
}
