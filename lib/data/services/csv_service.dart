import '../models/models.dart';

abstract class CsvService {
  Future<List<Entry>> readCsv(String url);
}
