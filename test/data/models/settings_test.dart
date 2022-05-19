import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';

void main() {
  group('Settings', () {
    group('constructor', () {
      test('works correctly', () {
        expect(() => const Settings(), returnsNormally);
      });

      test('returns object with default values', () {
        Settings settings = const Settings();
        expect(settings.appTheme, AppTheme.light);
        expect(settings.appFontSize, AppFontSize.standard);
      });

      test('sets parameters if provided', () {
        Settings settings = const Settings(
          appTheme: AppTheme.dark,
          appFontSize: AppFontSize.large,
        );
        expect(settings.appTheme, AppTheme.dark);
        expect(settings.appFontSize, AppFontSize.large);
      });

      test('supports value equality', () {
        Settings settings = const Settings();
        expect(settings, const Settings());
      });

      test('props are correct', () {
        Settings settings = const Settings();
        expect(settings.props, equals([AppTheme.light, AppFontSize.standard]));
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        Settings settings = const Settings();
        expect(settings.copyWith(), settings);
      });

      test('replaces every non null parameter', () {
        Settings settings = const Settings();
        expect(
          settings.copyWith(
            appTheme: AppTheme.dark,
            appFontSize: AppFontSize.small,
          ),
          const Settings(
            appTheme: AppTheme.dark,
            appFontSize: AppFontSize.small,
          ),
        );
      });
    });
  });
}
