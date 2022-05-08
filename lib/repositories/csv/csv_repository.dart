import '../../data/data.dart';

class CsvRepository {
  final CsvService _csvService;

  CsvRepository({required CsvService csvService}) : _csvService = csvService;

  Future<List<Entry>> readCsv(String url) => _csvService.readCsv(url);
}
