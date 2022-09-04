import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/settings/settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class FakeSettings extends Mock implements Settings {}

void main() {
  group('SettingsCubit', () {
    late SettingsRepository settingsRepository;
    late SettingsCubit settingsCubit;

    const defaultSettings = Settings();
    const storedSettings =
        Settings(appTheme: AppTheme.dark, appFontSize: AppFontSize.large);

    setUp(() {
      settingsRepository = MockSettingsRepository();
      settingsCubit = SettingsCubit(settingsRepository);
    });

    setUpAll(() {
      registerFallbackValue(FakeSettings());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => SettingsCubit(settingsRepository), returnsNormally);
      });

      test('initial state is correct', () {
        expect(settingsCubit.state, defaultSettings);
      });
    });

    group('readSettings', () {
      blocTest<SettingsCubit, Settings>(
        'emits stored settings when read settings successfully',
        setUp: () {
          when(() => settingsRepository.read()).thenReturn(storedSettings);
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => [storedSettings],
        verify: (_) {
          verify(() => settingsRepository.read()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits default settings when settings not found',
        setUp: () {
          when(() => settingsRepository.read()).thenReturn(null);
          when(() => settingsRepository.create()).thenAnswer((_) async {});
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => [defaultSettings],
        verify: (_) {
          verify(() => settingsRepository.read()).called(1);
          verify(() => settingsRepository.create()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits default settings when error occurs during reading settings',
        setUp: () {
          when(() => settingsRepository.read()).thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => [defaultSettings],
        verify: (_) {
          verify(() => settingsRepository.read()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits default settings when error occurs during creating settings',
        setUp: () {
          when(() => settingsRepository.create())
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => [defaultSettings],
        verify: (_) {
          verify(() => settingsRepository.create()).called(1);
        },
      );
    });

    group('updateAppTheme', () {
      blocTest<SettingsCubit, Settings>(
        'emits settings with updated app theme',
        setUp: () {
          when(() => settingsRepository.update(any())).thenAnswer((_) async {});
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppTheme(AppTheme.dark),
        expect: () => [defaultSettings.copyWith(appTheme: AppTheme.dark)],
        verify: (_) {
          verify(() => settingsRepository.update(
              defaultSettings.copyWith(appTheme: AppTheme.dark))).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits current settings when error occurs during updating settings',
        setUp: () {
          when(() => settingsRepository.update(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppTheme(AppTheme.dark),
        expect: () => [defaultSettings],
        verify: (_) {
          verify(() => settingsRepository.update(
              defaultSettings.copyWith(appTheme: AppTheme.dark))).called(1);
        },
      );
    });

    group('updateAppFontSize', () {
      blocTest<SettingsCubit, Settings>(
        'emits settings with updated font size',
        setUp: () {
          when(() => settingsRepository.update(any())).thenAnswer((_) async {});
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppFontSize(AppFontSize.large),
        expect: () =>
            [defaultSettings.copyWith(appFontSize: AppFontSize.large)],
        verify: (_) {
          verify(() => settingsRepository.update(
                  defaultSettings.copyWith(appFontSize: AppFontSize.large)))
              .called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits current settings when error occurs during updating settings',
        setUp: () {
          when(() => settingsRepository.update(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppFontSize(AppFontSize.large),
        expect: () => [defaultSettings],
        verify: (_) {
          verify(() => settingsRepository.update(
                  defaultSettings.copyWith(appFontSize: AppFontSize.large)))
              .called(1);
        },
      );
    });
  });
}
