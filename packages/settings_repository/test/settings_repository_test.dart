import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<Settings> {}

class FakeSettings extends Mock implements Settings {}

void main() {
  group('SettingsRepository', () {
    late HiveInterface mockHive;
    late Box<Settings> mockBox;
    late SettingsRepository settingsRepository;

    setUp(() async {
      mockHive = MockHive();
      mockBox = MockBox();

      when(() => mockHive.openBox<Settings>(any()))
          .thenAnswer((_) async => mockBox);

      settingsRepository = await SettingsRepository.init(mockHive);
    });

    setUpAll(() {
      registerFallbackValue(FakeSettings());
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () async => await SettingsRepository.init(mockHive),
          returnsNormally,
        );
      });
    });

    group('create', () {
      test('creates settings', () {
        when(() => mockBox.put(any(), any())).thenAnswer((_) async => 0);

        expect(settingsRepository.create(), completes);
        verify(() => mockBox.put(0, const Settings())).called(1);
      });
    });

    group('update', () {
      test('updates settings', () {
        when(() => mockBox.putAt(any(), any()))
            .thenAnswer((_) async => Future.value);

        expect(settingsRepository.update(const Settings()), completes);
        verify(() => mockBox.putAt(0, const Settings())).called(1);
      });
    });

    group('read', () {
      test('reads settings', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => false);
        when(() => mockBox.getAt(any())).thenAnswer((_) => const Settings());

        expect(settingsRepository.read(), const Settings());
        verify(() => mockBox.isEmpty).called(1);
        verify(() => mockBox.getAt(0)).called(1);
      });

      test('returns null when settings not found', () {
        when(() => mockBox.isEmpty).thenAnswer((_) => true);

        expect(settingsRepository.read(), null);
        verify(() => mockBox.isEmpty).called(1);
      });
    });
  });
}
