import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsDataSource extends Mock implements SettingsDataSource {}

void main() {
  group('SettingsRepository', () {
    late SettingsDataSource mockDataSource;
    late SettingsRepository repository;
    Settings settings =
        const Settings(appTheme: AppTheme.dark, appFontSize: AppFontSize.small);

    setUp(() {
      mockDataSource = MockSettingsDataSource();
      repository = SettingsRepository(mockDataSource);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => SettingsRepository(mockDataSource), returnsNormally);
      });
    });

    group('createSettings', () {
      test('creates new settings', () {
        when(() => mockDataSource.createSettings())
            .thenAnswer((_) async => Future.value);

        expect(repository.createSettings(), completes);
        verify(() => mockDataSource.createSettings()).called(1);
      });
    });

    group('updateSettings', () {
      test('updates existing settings', () {
        when(() => mockDataSource.updateSettings(settings))
            .thenAnswer((_) async => Future.value);

        expect(repository.updateSettings(settings), completes);
        verify(() => mockDataSource.updateSettings(settings)).called(1);
      });
    });

    group('readSettings', () {
      test('reads existing settings', () {
        when(() => mockDataSource.readSettings()).thenAnswer((_) => settings);

        expect(repository.readSettings(), settings);
        verify(() => mockDataSource.readSettings()).called(1);
      });

      test('returns null when settings not exists', () {
        when(() => mockDataSource.readSettings()).thenAnswer((_) => null);

        expect(repository.readSettings(), null);
        verify(() => mockDataSource.readSettings()).called(1);
      });
    });
  });
}
