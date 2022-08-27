import 'dart:io';
import 'dart:typed_data';

import 'package:csv_repository/csv_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('CsvRepository', () {
    late http.Client httpClient;
    late CsvRepository csvRepository;

    setUp(() {
      httpClient = MockHttpClient();
      csvRepository = CsvRepository(httpClient: httpClient);
    });

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    group('constructor', () {
      test('does not require http client', () {
        expect(() => CsvRepository(), returnsNormally);
      });

      test('works properly when http client provided', () {
        expect(() => CsvRepository(httpClient: httpClient), returnsNormally);
      });
    });

    group('fetchData', () {
      final csvUrl = 'url';
      final csvString = 'title1",content1\r\ntitle2,content2';
      final csvData = [
        ['title1', 'content1'],
        ['title2', 'content2'],
      ];

      test('fetches csv data', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(csvString);
        when(() => response.bodyBytes)
            .thenReturn(Uint8List.fromList(csvString.codeUnits));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final result = await csvRepository.fetchData(csvUrl);

        expect(result, equals(csvData));
      });

      test('throws NoInternetAccessFailure when SocketException occured', () {
        when(() => httpClient.get(any())).thenThrow(SocketException('failure'));

        expect(
          () async => await csvRepository.fetchData(csvUrl),
          throwsA(isA<NoInternetAccessFailure>()),
        );
      });

      test('throws RequestFailure when status code is not equal 200', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvRepository.fetchData(csvUrl),
          throwsA(isA<RequestFailure>()),
        );
      });

      test('throws NoDataFailure when csv file is empty', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvRepository.fetchData(csvUrl),
          throwsA(isA<NoDataFailure>()),
        );
      });

      test('throws WrongFormatFailure when csv data format is wrong', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('aa,bb,cc');
        when(() => response.bodyBytes)
            .thenReturn(Uint8List.fromList('aa,bb,cc'.codeUnits));
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => await csvRepository.fetchData(csvUrl),
          throwsA(isA<WrongFormatFailure>()),
        );
      });
    });
  });
}
