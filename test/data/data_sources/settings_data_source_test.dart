import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';

class TestSettingsDataSource extends SettingsDataSource {
  TestSettingsDataSource() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('SettingsDataSource', () {
    test('can be constructed', () {
      expect(TestSettingsDataSource.new, returnsNormally);
    });
  });
}
