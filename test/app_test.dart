import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/app.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  group('App', () {
    late DeckRepository deckRepository;
    late SettingsRepository settingsRepository;
    late CsvRepository csvRepository;

    setUp(() {
      deckRepository = MockDeckRepository();
      settingsRepository = MockSettingsRepository();
      csvRepository = MockCsvRepository();
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          deckRepository: deckRepository,
          settingsRepository: settingsRepository,
          csvRepository: csvRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late SettingsCubit settingsCubit;
    late DeckRepository deckRepository;

    setUp(() {
      settingsCubit = MockSettingsCubit();
      deckRepository = MockDeckRepository();
    });
    testWidgets('renders HomePage', (tester) async {
      when(() => settingsCubit.readSettings())
          .thenAnswer((_) async => Future.value);
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {
        yield const Settings();
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: BlocProvider.value(
            value: settingsCubit..readSettings(),
            child: const AppView(),
          ),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('has correct theme and font size', (tester) async {
      when(() => settingsCubit.readSettings())
          .thenAnswer((_) async => Future.value);
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {
        yield const Settings();
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: BlocProvider.value(
            value: settingsCubit..readSettings(),
            child: const AppView(),
          ),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
          materialApp.theme,
          AppThemeData.getTheme(
              appTheme: AppTheme.light, appFontSize: AppFontSize.standard));
    });
  });
}
