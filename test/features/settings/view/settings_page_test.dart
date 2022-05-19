import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  group('SettingsPage', () {
    late SettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = MockSettingsCubit();
    });

    setUpAll(() {
      registerFallbackValue(AppTheme.light);
      registerFallbackValue(AppFontSize.standard);
    });

    testWidgets('renders correct widgets', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {});

      await tester.pumpWidget(
        BlocProvider.value(
          value: settingsCubit,
          child: const MaterialApp(home: SettingsPage()),
        ),
      );

      expect(find.byType(RadioListTile<AppTheme>), findsNWidgets(2));
      expect(find.byType(RadioListTile<AppFontSize>), findsNWidgets(3));

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('light'), findsOneWidget);
      expect(find.text('dark'), findsOneWidget);
      expect(find.text('Font size'), findsOneWidget);
      expect(find.text('small'), findsOneWidget);
      expect(find.text('standard'), findsOneWidget);
      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('proper radios are checked', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {});

      await tester.pumpWidget(
        BlocProvider.value(
          value: settingsCubit,
          child: const MaterialApp(home: SettingsPage()),
        ),
      );

      final radioLight = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_lightTheme_radioListTile')));
      final radioDark = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_darkTheme_radioListTile')));
      final radioSmall = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_smallFont_radioListTile')));
      final radioStandard = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_standardFont_radioListTile')));
      final radioLarge = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_largeFont_radioListTile')));

      expect(radioLight.checked, true);
      expect(radioDark.checked, false);
      expect(radioSmall.checked, false);
      expect(radioStandard.checked, true);
      expect(radioLarge.checked, false);
    });

    testWidgets('updates settings when radio tapped', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {});

      when(() => settingsCubit.readSettings())
          .thenAnswer((_) async => Future.value);
      when(() => settingsCubit.updateAppTheme(any()))
          .thenAnswer((_) async => Future.value);
      when(() => settingsCubit.updateAppFontSize(any()))
          .thenAnswer((_) async => Future.value);

      await tester.pumpWidget(
        BlocProvider.value(
          value: settingsCubit..readSettings(),
          child: const MaterialApp(home: SettingsPage()),
        ),
      );

      await tester
          .tap(find.byKey(const Key('settingsPage_darkTheme_radioListTile')));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('settingsPage_largeFont_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppTheme(AppTheme.dark)).called(1);
      verify(() => settingsCubit.updateAppFontSize(AppFontSize.large))
          .called(1);
    });
  });
}
