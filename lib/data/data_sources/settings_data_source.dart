import '../models/models.dart';

abstract class SettingsDataSource {
  Future<void> createSettings();
  Future<void> updateSettings(Settings settings);
  Settings? readSettings();
}
