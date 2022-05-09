import 'package:hive_flutter/hive_flutter.dart';

import '../../models/settings.dart';
import '../data_sources.dart';

class HiveSettingsDataSource extends SettingsDataSource {
  final Box<Settings> _box;

  HiveSettingsDataSource._(this._box);

  static Future<HiveSettingsDataSource> create() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(ThemeAdapter());
    Hive.registerAdapter(FontSizeAdapter());
    final box = await Hive.openBox<Settings>('settings');
    return HiveSettingsDataSource._(box);
  }

  @override
  Future<void> createSettings() async {
    await _box.add(const Settings());
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    await _box.putAt(0, settings);
  }

  @override
  Settings? readSettings() {
    if (_box.values.isEmpty) {
      return null;
    } else {
      return _box.values.first;
    }
  }
}
