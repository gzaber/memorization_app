import 'package:hive/hive.dart';
import 'package:settings_repository/settings_repository.dart';

class SettingsRepository {
  SettingsRepository._(this._box);

  final Box<Settings> _box;

  static Future<SettingsRepository> init(HiveInterface hive) async {
    hive.registerAdapter(SettingsAdapter());
    hive.registerAdapter(AppThemeAdapter());
    hive.registerAdapter(AppFontSizeAdapter());
    final box = await hive.openBox<Settings>('settings');
    return SettingsRepository._(box);
  }

  Future<void> create() async {
    await _box.put(0, const Settings());
  }

  Future<void> update(Settings settings) async {
    await _box.putAt(0, settings);
  }

  Settings? read() {
    if (_box.isEmpty) {
      return null;
    } else {
      return _box.getAt(0);
    }
  }
}
