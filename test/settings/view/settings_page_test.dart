import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/settings/settings.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_repository/settings_repository.dart';

extension PumpView on WidgetTester {
  Future<void> pumpSettingsPage({required SettingsCubit settingsCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: settingsCubit,
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );
  }
}

class MockSettingsCubit extends MockCubit<Settings> implements SettingsCubit {}

void main() {
  late SettingsCubit settingsCubit;

  setUp(() {
    settingsCubit = MockSettingsCubit();
  });

  setUpAll(() {
    registerFallbackValue(AppTheme.light);
    registerFallbackValue(AppFontSize.medium);
  });

  group('SettingsPage', () {
    testWidgets('is routable', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpWidget(
        BlocProvider.value(
          value: settingsCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(SettingsPage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('renders AppBar with back button and title', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text('Settings')),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.byType(IconButton)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.arrow_back)),
        findsOneWidget,
      );
    });

    testWidgets('renders correct widgets', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      expect(find.byType(RadioListTile<AppTheme>), findsNWidgets(2));
      expect(find.byType(RadioListTile<AppFontSize>), findsNWidgets(3));

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('light'), findsOneWidget);
      expect(find.text('dark'), findsOneWidget);
      expect(find.text('Font size'), findsOneWidget);
      expect(find.text('small'), findsOneWidget);
      expect(find.text('medium'), findsOneWidget);
      expect(find.text('large'), findsOneWidget);
    });

    testWidgets('proper radios are checked', (tester) async {
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      final radioLight = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_lightTheme_radioListTile')));
      final radioDark = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_darkTheme_radioListTile')));
      final radioSmall = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_smallFont_radioListTile')));
      final radioMedium = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_mediumFont_radioListTile')));
      final radioLarge = tester.widget<RadioListTile>(
          find.byKey(const Key('settingsPage_largeFont_radioListTile')));

      expect(radioLight.checked, true);
      expect(radioDark.checked, false);
      expect(radioSmall.checked, false);
      expect(radioMedium.checked, true);
      expect(radioLarge.checked, false);
    });

    testWidgets('updates settings when dark theme radio tapped',
        (tester) async {
      when(() => settingsCubit.state)
          .thenReturn(const Settings(appTheme: AppTheme.light));
      when(() => settingsCubit.updateAppTheme(any())).thenAnswer((_) async {});

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      await tester
          .tap(find.byKey(const Key('settingsPage_darkTheme_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppTheme(AppTheme.dark)).called(1);
    });

    testWidgets('updates settings when light theme radio tapped',
        (tester) async {
      when(() => settingsCubit.state)
          .thenReturn(const Settings(appTheme: AppTheme.dark));

      when(() => settingsCubit.updateAppTheme(any())).thenAnswer((_) async {});

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      await tester
          .tap(find.byKey(const Key('settingsPage_lightTheme_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppTheme(AppTheme.light)).called(1);
    });

    testWidgets('updates settings when medium font radio tapped',
        (tester) async {
      when(() => settingsCubit.state)
          .thenReturn(const Settings(appFontSize: AppFontSize.small));
      when(() => settingsCubit.updateAppFontSize(any()))
          .thenAnswer((_) async {});

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      await tester
          .tap(find.byKey(const Key('settingsPage_mediumFont_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppFontSize(AppFontSize.medium))
          .called(1);
    });

    testWidgets('updates settings when large font radio tapped',
        (tester) async {
      when(() => settingsCubit.state)
          .thenReturn(const Settings(appFontSize: AppFontSize.small));
      when(() => settingsCubit.updateAppFontSize(any()))
          .thenAnswer((_) async {});

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      await tester
          .tap(find.byKey(const Key('settingsPage_largeFont_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppFontSize(AppFontSize.large))
          .called(1);
    });

    testWidgets('updates settings when small font radio tapped',
        (tester) async {
      when(() => settingsCubit.state)
          .thenReturn(const Settings(appFontSize: AppFontSize.medium));
      when(() => settingsCubit.updateAppFontSize(any()))
          .thenAnswer((_) async {});

      await tester.pumpSettingsPage(settingsCubit: settingsCubit);

      await tester
          .tap(find.byKey(const Key('settingsPage_smallFont_radioListTile')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit.updateAppFontSize(AppFontSize.small))
          .called(1);
    });

    testWidgets('pops when back button is tapped', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});
      when(() => settingsCubit.state).thenReturn(const Settings());

      await tester.pumpWidget(
        BlocProvider.value(
          value: settingsCubit,
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: const SettingsPage(),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));

      verify(() => navigator.pop()).called(1);
    });
  });
}
