import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/repositories/csv/csv_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockCsvService extends Mock implements CsvService {}

void main() {
  group('CsvRepository', () {
    late CsvService mockCsvService;
    late CsvRepository repository;

    setUp(() {
      mockCsvService = MockCsvService();
      repository = CsvRepository(mockCsvService);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => CsvRepository(mockCsvService), returnsNormally);
      });
    });

    group('readCsv', () {
      test('reads csv data', () async {
        const csvUrl = 'url';
        final entries = [Entry(title: 'title', description: 'description')];

        when(() => mockCsvService.readCsv(any()))
            .thenAnswer((_) async => entries);

        expect(repository.readCsv(csvUrl), completes);
        verify(() => mockCsvService.readCsv(csvUrl)).called(1);
      });

      test('throws Exception when failure occurs', () async {
        const csvUrl = 'url';
        when(() => mockCsvService.readCsv(any())).thenThrow(Exception());

        expect(repository.readCsv(csvUrl), throwsA(isA<Exception>()));
        verify(() => mockCsvService.readCsv(csvUrl)).called(1);
      });
    });
  });
}
