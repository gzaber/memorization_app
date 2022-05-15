import 'package:flutter/material.dart';

import 'app.dart';
import 'data/data.dart';
import 'repositories/repositories.dart';

void main() async {
  final DeckDataSource _deckDataSource = await HiveDeckDataSource.create();
  final SettingsDataSource _settingsDataSource =
      await HiveSettingsDataSource.create();
  final CsvService _csvService = GoogleSheetsCsvService();

  runApp(
    App(
      deckRepository: DeckRepository(_deckDataSource),
      settingsRepository: SettingsRepository(_settingsDataSource),
      csvRepository: CsvRepository(_csvService),
    ),
  );
}
