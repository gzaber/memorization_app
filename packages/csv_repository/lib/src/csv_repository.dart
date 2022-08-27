import 'dart:io';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class NoInternetAccessFailure implements Exception {}

class RequestFailure implements Exception {}

class NoDataFailure implements Exception {}

class WrongFormatFailure implements Exception {}

class CsvRepository {
  CsvRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<List<List<String>>> fetchData(String url) async {
    try {
      final List<List<String>> entries = [];

      final response = await _httpClient.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw RequestFailure();
      }

      if (response.body.isEmpty) {
        throw NoDataFailure();
      }

      final rowsAsListOfValues =
          const CsvToListConverter().convert(utf8.decode(response.bodyBytes));

      for (final row in rowsAsListOfValues) {
        if (row.length != 2) {
          throw WrongFormatFailure();
        }

        entries.add([row[0].toString(), row[1].toString()]);
      }
      return entries;
    } on SocketException {
      throw NoInternetAccessFailure();
    } on Exception {
      rethrow;
    }
  }
}
