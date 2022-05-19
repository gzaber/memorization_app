import 'package:hive_flutter/hive_flutter.dart';

import '../../models/settings.dart';
import '../data_sources.dart';

class HiveSettingsDataSource extends SettingsDataSource {
  final Box<Settings> _box;

  HiveSettingsDataSource._(this._box);

  static Future<HiveSettingsDataSource> create(HiveInterface hive) async {
    await hive.initFlutter();
    hive.registerAdapter(SettingsAdapter());
    hive.registerAdapter(AppThemeAdapter());
    hive.registerAdapter(AppFontSizeAdapter());
    final box = await hive.openBox<Settings>('settings');
    return HiveSettingsDataSource._(box);
  }

  @override
  Future<void> createSettings() async {
    await _box.put(0, const Settings());
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    await _box.putAt(0, settings);
  }

  @override
  Settings? readSettings() {
    if (_box.isEmpty) {
      return null;
    } else {
      return _box.getAt(0);
    }
  }
}
