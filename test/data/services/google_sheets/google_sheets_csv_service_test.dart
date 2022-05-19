import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('GoogleSheetsCsvService', () {
    late http.Client httpClient;
    late GoogleSheetsCsvService csvService;

    setUp(() {
      httpClient = MockHttpClient();
      csvService = GoogleSheetsCsvService(httpClient);
    });

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => GoogleSheetsCsvService(httpClient), returnsNormally);
      });
    });

    group('readCsv', () {
      const csvUrl = 'url';
      const csvString = 'title,description';

      test('reads csv data', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(csvString);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        late List<Entry> result;
        try {
          result = await csvService.readCsv(csvUrl);
        } catch (_) {}

        expect(result, isA<List<Entry>>());
        expect(result, isNotEmpty);
        expect(result.first.title, 'title');
        expect(result.first.description, 'description');
      });

      test('throws Exception when status code is not equal 200', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvService.readCsv(csvUrl),
          throwsA(isA<Exception>()),
        );
      });

      test('throws Exception when csv file is empty', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvService.readCsv(csvUrl),
          throwsA(isA<Exception>()),
        );
      });

      test('throws Exception when data format is wrong', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('aa,bb,cc');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvService.readCsv(csvUrl),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
