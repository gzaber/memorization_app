import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'data/data.dart';
import 'repositories/repositories.dart';

void main() async {
  final DeckDataSource _deckDataSource = await HiveDeckDataSource.create(Hive);
  final SettingsDataSource _settingsDataSource =
      await HiveSettingsDataSource.create(Hive);
  final CsvService _csvService = GoogleSheetsCsvService(http.Client());

  runApp(
    App(
      deckRepository: DeckRepository(_deckDataSource),
      settingsRepository: SettingsRepository(_settingsDataSource),
      csvRepository: CsvRepository(_csvService),
    ),
  );
}
