import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorization_app/data/data.dart';
import 'package:mocktail/mocktail.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Settings> {}

class FakeSettings extends Mock implements Settings {}

void main() {
  group('HiveSettingsDataSource', () {
    late HiveInterface mockHive;
    late Box<Settings> mockBox;
    late HiveSettingsDataSource dataSource;

    setUpAll(() {
      registerFallbackValue(FakeSettings());
    });

    setUp(() async {
      mockHive = MockHive();
      mockBox = MockBox();

      when(() => mockHive.openBox<Settings>(any()))
          .thenAnswer((_) async => mockBox);

      dataSource = await HiveSettingsDataSource.create(mockHive);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() async => await HiveSettingsDataSource.create(mockHive),
            returnsNormally);
      });
    });

    group('createSettings', () {
      test('creates new settings', () {
        when(() => mockBox.put(any(), any())).thenAnswer((_) async => 0);

        expect(dataSource.createSettings(), completes);
        verify(() => mockBox.put(0, const Settings())).called(1);
      });
    });

    group('updateSettings', () {
      test('updates existing settings', () {
        when(() => mockBox.putAt(any(), any()))
            .thenAnswer((_) async => Future.value);

        expect(dataSource.updateSettings(const Settings()), completes);
        verify(() => mockBox.putAt(0, const Settings())).called(1);
      });
    });

    group('readSettings', () {
      test('reads existing settings', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => false);
        when(() => mockBox.getAt(any())).thenAnswer((_) => const Settings());

        expect(dataSource.readSettings(), const Settings());
        verify(() => mockBox.isEmpty).called(1);
        verify(() => mockBox.getAt(0)).called(1);
      });

      test('returns null when settings not exists', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => true);

        expect(dataSource.readSettings(), null);
        verify(() => mockBox.isEmpty).called(1);
      });
    });
  });
}
