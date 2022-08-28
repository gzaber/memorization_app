import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Settings', () {
    Settings createSettings({
      AppTheme appTheme = AppTheme.light,
      AppFontSize appFontSize = AppFontSize.medium,
    }) {
      return Settings(
        appTheme: appTheme,
        appFontSize: appFontSize,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createSettings(), returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createSettings(), equals(createSettings()));
    });

    test('props are correct', () {
      expect(
        createSettings().props,
        equals([AppTheme.light, AppFontSize.medium]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSettings().copyWith(),
          equals(createSettings()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createSettings().copyWith(appTheme: null, appFontSize: null),
          equals(createSettings()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createSettings().copyWith(
              appTheme: AppTheme.dark, appFontSize: AppFontSize.large),
          equals(
            createSettings(
                appTheme: AppTheme.dark, appFontSize: AppFontSize.large),
          ),
        );
      });
    });
  });
}
