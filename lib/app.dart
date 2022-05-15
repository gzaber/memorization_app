import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data.dart';
import 'features/features.dart';
import 'repositories/repositories.dart';

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

class AppThemeData {
  static ThemeData getTheme({
    required AppTheme appTheme,
    required AppFontSize appFontSize,
  }) {
    final ThemeData baseTheme =
        appTheme == AppTheme.light ? ThemeData.light() : ThemeData.dark();

    return baseTheme.copyWith(
      textTheme: TextTheme(
        headline5: baseTheme.textTheme.headline5!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 22.0
              : appFontSize == AppFontSize.standard
                  ? 24.0
                  : 28.0,
          fontWeight: FontWeight.w300,
        ),
        headline6: baseTheme.textTheme.headline6!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 18.0
              : appFontSize == AppFontSize.standard
                  ? 20.0
                  : 24.0,
          fontWeight: FontWeight.w400,
        ),
        button: baseTheme.textTheme.button!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12.0
              : appFontSize == AppFontSize.standard
                  ? 14.0
                  : 18.0,
        ),
        subtitle1: baseTheme.textTheme.subtitle1!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 14.0
              : appFontSize == AppFontSize.standard
                  ? 16.0
                  : 20.0,
        ),
        bodyText2: baseTheme.textTheme.bodyText2!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12.0
              : appFontSize == AppFontSize.standard
                  ? 14.0
                  : 18.0,
        ),
      ),
    );
  }
}
