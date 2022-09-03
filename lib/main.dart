import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:settings_repository/settings_repository.dart';

import 'app/app.dart';

void main() async {
  await Hive.initFlutter();

  final CsvRepository csvRepository = CsvRepository();
  final DecksRepository decksRepository = await DecksRepository.init(Hive);
  final SettingsRepository settingsRepository =
      await SettingsRepository.init(Hive);

  runApp(
    App(
      csvRepository: csvRepository,
      decksRepository: decksRepository,
      settingsRepository: settingsRepository,
    ),
  );
}
