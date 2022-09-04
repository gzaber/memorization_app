import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Settings', () {
    group('constructor', () {
      test('works properly', () {
        expect(() => Settings(), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(Settings(), equals(Settings()));
    });

    test('props are correct', () {
      expect(
        Settings().props,
        equals([AppTheme.light, AppFontSize.medium]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          Settings().copyWith(),
          equals(Settings()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          Settings().copyWith(appTheme: null, appFontSize: null),
          equals(Settings()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          Settings().copyWith(
              appTheme: AppTheme.dark, appFontSize: AppFontSize.large),
          equals(
            Settings(appTheme: AppTheme.dark, appFontSize: AppFontSize.large),
          ),
        );
      });
    });
  });
}
