import '../../data/data.dart';

class SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepository({required SettingsDataSource dataSource})
      : _dataSource = dataSource;

  Future<void> createSettings() => _dataSource.createSettings();

  Future<void> updateSettings(Settings settings) =>
      _dataSource.updateSettings(settings);

  Settings? readSettings() => _dataSource.readSettings();
}
