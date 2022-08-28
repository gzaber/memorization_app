import 'package:bloc_test/bloc_test.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/app/app.dart';
import 'package:memorization_app/app/app_theme_data.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';
import 'package:memorization_app/settings/settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';

extension PumpView on WidgetTester {
  Future<void> pumpAppView({
    required SettingsCubit settingsCubit,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: settingsCubit,
        child: const AppView(),
      ),
    );
  }
}

class MockDecksRepository extends Mock implements DecksRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockSettingsCubit extends MockCubit<Settings> implements SettingsCubit {}

void main() {
  group('App', () {
    late CsvRepository csvRepository;
    late DecksRepository decksRepository;
    late SettingsRepository settingsRepository;

    setUp(() {
      csvRepository = MockCsvRepository();
      decksRepository = MockDecksRepository();
      settingsRepository = MockSettingsRepository();
    });

    testWidgets('renders AppView', (tester) async {
      when(() => settingsRepository.read()).thenAnswer((_) => const Settings());

      await tester.pumpWidget(
        App(
          csvRepository: csvRepository,
          decksRepository: decksRepository,
          settingsRepository: settingsRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late SettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = MockSettingsCubit();
    });

    testWidgets('renders DecksOverviewPage', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpAppView(settingsCubit: settingsCubit);

      expect(find.byType(DecksOverviewPage), findsOneWidget);
    });

    testWidgets('has correct theme and font size', (tester) async {
      when(() => settingsCubit.state).thenReturn(
        const Settings(
          appTheme: AppTheme.dark,
          appFontSize: AppFontSize.small,
        ),
      );

      await tester.pumpAppView(settingsCubit: settingsCubit);
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(
        materialApp.theme,
        AppThemeData.getTheme(
            appTheme: AppTheme.dark, appFontSize: AppFontSize.small),
      );
    });
  });
}
