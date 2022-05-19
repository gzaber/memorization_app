import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('HomeState', () {
    group('HomeLoading', () {
      test('constructor works properly', () {
        expect(() => HomeLoading(), returnsNormally);
      });
    });

    group('HomeSuccess', () {
      final List<Deck> decks = [const Deck(name: 'name', url: 'url')];
      test('constructor works properly', () {
        expect(() => HomeSuccess(decks), returnsNormally);
      });

      test('supports value comparison', () {
        expect(HomeSuccess(decks), HomeSuccess(decks));
      });
    });

    group('HomeFailure', () {
      const errorMessage = 'error message';
      test('constructor works properly', () {
        expect(() => const HomeFailure(errorMessage), returnsNormally);
      });

      test('supports value comparison', () {
        expect(
            const HomeFailure(errorMessage), const HomeFailure(errorMessage));
      });
    });
  });
}
