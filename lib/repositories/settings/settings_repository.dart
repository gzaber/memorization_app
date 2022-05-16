import '../../data/data.dart';

class SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepository(this._dataSource);

  Future<void> createSettings() async => await _dataSource.createSettings();

  Future<void> updateSettings(Settings settings) async =>
      await _dataSource.updateSettings(settings);

  Settings? readSettings() => _dataSource.readSettings();
}
