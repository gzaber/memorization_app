import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';
import 'package:memorization_app/settings/settings.dart';
import 'package:settings_repository/settings_repository.dart';

import 'app_theme_data.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required CsvRepository csvRepository,
    required DecksRepository decksRepository,
    required SettingsRepository settingsRepository,
  })  : _csvRepository = csvRepository,
        _decksRepository = decksRepository,
        _settingsRepository = settingsRepository,
        super(key: key);

  final CsvRepository _csvRepository;
  final DecksRepository _decksRepository;
  final SettingsRepository _settingsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _csvRepository),
        RepositoryProvider.value(value: _decksRepository),
        RepositoryProvider.value(value: _settingsRepository),
      ],
      child: BlocProvider(
        create: (context) => SettingsCubit(_settingsRepository)..readSettings(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.select((SettingsCubit cubit) => cubit.state);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MemorizationApp',
      theme: AppThemeData.getTheme(
        appTheme: settings.appTheme,
        appFontSize: settings.appFontSize,
      ),
      home: const DecksOverviewPage(),
    );
  }
}
