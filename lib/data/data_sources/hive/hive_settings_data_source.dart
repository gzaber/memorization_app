import 'package:hive/hive.dart';

import '../../models/settings.dart';
import '../data_sources.dart';

class HiveSettingsDataSource extends SettingsDataSource {
  final Box<Settings> _box;

  HiveSettingsDataSource({required Box<Settings> box}) : _box = box;

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
