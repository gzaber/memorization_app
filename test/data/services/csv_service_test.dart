import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';

class TestCsvService extends CsvService {
  TestCsvService() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('CsvService', () {
    test('can be constructed', () {
      expect(TestCsvService.new, returnsNormally);
    });
  });
}
