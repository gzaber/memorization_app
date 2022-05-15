import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data.dart';
import 'presentation/presentation.dart';
import 'repositories/repositories.dart';
import 'state_management/state_management.dart';

class App extends StatelessWidget {
  final DeckRepository _deckRepository;
  final SettingsRepository _settingsRepository;
  final CsvRepository _csvRepository;

  const App({
    Key? key,
    required DeckRepository deckRepository,
    required SettingsRepository settingsRepository,
    required CsvRepository csvRepository,
  })  : _deckRepository = deckRepository,
        _settingsRepository = settingsRepository,
        _csvRepository = csvRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _deckRepository,
        ),
        RepositoryProvider(
          create: (context) => _settingsRepository,
        ),
        RepositoryProvider(
          create: (context) => _csvRepository,
        ),
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
    return BlocBuilder<SettingsCubit, Settings>(
      builder: (context, settings) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MemorizationApp',
          theme: AppThemeData.getTheme(
            appTheme: settings.appTheme,
            appFontSize: settings.appFontSize,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
