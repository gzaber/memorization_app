import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

import '../../models/deck.dart';
import '../services.dart';

class GoogleSheetsCsvService extends CsvService {
  final http.Client _httpClient;

  GoogleSheetsCsvService(this._httpClient);

  @override
  Future<List<Entry>> readCsv(String url) async {
    List<Entry> entries = [];
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Request failure');
    }

    if (response.body.isEmpty) {
      throw Exception('No data');
    }

    final rowsAsListOfValues =
        const CsvToListConverter().convert(utf8.decode(response.bodyBytes));

    for (final row in rowsAsListOfValues) {
      if (row.length != 2) {
        throw Exception('Wrong format');
      }

      entries.add(
        Entry(title: row[0], description: row[1]),
      );
    }
    return entries;
  }
}
