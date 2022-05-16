import '../../data/data.dart';

class CsvRepository {
  final CsvService _csvService;

  CsvRepository(this._csvService);

  Future<List<Entry>> readCsv(String url) async =>
      await _csvService.readCsv(url);
}
