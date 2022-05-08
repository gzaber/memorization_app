import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

import '../../models/deck.dart';
import '../services.dart';

class GoogleSheetsCsvService extends CsvService {
  @override
  Future<List<Entry>> readCsv(String url) async {
    List<Entry> entries = [];
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Request failure');
    }

    if (response.body.isEmpty) {
      throw Exception('No data');
    }

    final rowsAsListOfValues =
        const CsvToListConverter().convert(response.body);

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
