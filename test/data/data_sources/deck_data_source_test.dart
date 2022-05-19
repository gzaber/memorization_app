import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';

class TestDeckDataSource extends DeckDataSource {
  TestDeckDataSource() : super();

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('DeckDataSource', () {
    test('can be constructed', () {
      expect(TestDeckDataSource.new, returnsNormally);
    });
  });
}
