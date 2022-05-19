import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class FakeSettings extends Mock implements Settings {}

void main() {
  group('SettingsCubit', () {
    late SettingsRepository repository;
    late SettingsCubit settingsCubit;

    setUp(() {
      repository = MockSettingsRepository();
      settingsCubit = SettingsCubit(repository);
    });

    setUpAll(() {
      registerFallbackValue(FakeSettings());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => SettingsCubit(repository), returnsNormally);
      });

      test('initial default state is correct', () {
        final settingsCubit = SettingsCubit(repository);
        expect(settingsCubit.state, const Settings());
        expect(settingsCubit.state.appTheme, AppTheme.light);
        expect(settingsCubit.state.appFontSize, AppFontSize.standard);
      });
    });

    group('readSettings', () {
      blocTest<SettingsCubit, Settings>(
        'emits correct state if exists',
        setUp: () {
          when(() => repository.readSettings()).thenReturn(
            const Settings(
              appTheme: AppTheme.dark,
              appFontSize: AppFontSize.large,
            ),
          );
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => const <Settings>[
          Settings(appTheme: AppTheme.dark, appFontSize: AppFontSize.large)
        ],
        verify: (_) {
          verify(() => repository.readSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits default state if error occurs during reading settings',
        setUp: () {
          when(() => repository.readSettings()).thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => const <Settings>[Settings()],
        verify: (_) {
          verify(() => repository.readSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'creates default state and emits it if not exists',
        setUp: () {
          when(() => repository.readSettings()).thenReturn(null);
          when(() => repository.createSettings())
              .thenAnswer((_) async => Future.value);
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => const <Settings>[
          Settings(),
        ],
        verify: (_) {
          verify(() => repository.readSettings()).called(1);
          verify(() => repository.createSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits default state if error occurs during creating settings',
        setUp: () {
          when(() => repository.createSettings())
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.readSettings(),
        expect: () => const <Settings>[Settings()],
        verify: (_) {
          verify(() => repository.createSettings()).called(1);
        },
      );
    });

    group('updateAppTheme', () {
      blocTest<SettingsCubit, Settings>(
        'emits updated by app theme state',
        setUp: () {
          when(() => repository.updateSettings(any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppTheme(AppTheme.dark),
        expect: () => const <Settings>[Settings(appTheme: AppTheme.dark)],
        verify: (_) {
          verify(() => repository.updateSettings(
              const Settings(appTheme: AppTheme.dark))).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits current state if error occurs during updating settings',
        setUp: () {
          when(() => repository.updateSettings(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppTheme(AppTheme.dark),
        expect: () => const <Settings>[Settings()],
        verify: (_) {
          verify(() => repository.updateSettings(
              const Settings(appTheme: AppTheme.dark))).called(1);
        },
      );
    });

    group('updateAppFontSize', () {
      blocTest<SettingsCubit, Settings>(
        'emits updated by app font size state',
        setUp: () {
          when(() => repository.updateSettings(any()))
              .thenAnswer((_) async => Future.value);
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppFontSize(AppFontSize.large),
        expect: () =>
            const <Settings>[Settings(appFontSize: AppFontSize.large)],
        verify: (_) {
          verify(() => repository.updateSettings(
              const Settings(appFontSize: AppFontSize.large))).called(1);
        },
      );

      blocTest<SettingsCubit, Settings>(
        'emits current state if error occurs during updating settings',
        setUp: () {
          when(() => repository.updateSettings(any()))
              .thenThrow(Exception('failure'));
        },
        build: () => settingsCubit,
        act: (cubit) => cubit.updateAppFontSize(AppFontSize.large),
        expect: () => const <Settings>[Settings()],
        verify: (_) {
          verify(() => repository.updateSettings(
              const Settings(appFontSize: AppFontSize.large))).called(1);
        },
      );
    });
  });
}
