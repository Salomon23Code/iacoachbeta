import '../models/weigth_record.dart';
import 'api_service.dart';

class WeightService {
  final ApiService _apiService;

  WeightService(this._apiService);

  Future<List<WeightRecord>> getRecords(int userId) async {
    final response = await _apiService.get('/weights/user/$userId');
    final data = response['data'];
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(WeightRecord.fromJson)
        .toList();
  }

  Future<WeightRecord> createRecord({
    required int userId,
    required double weight,
    DateTime? date,
  }) async {
    final response = await _apiService.post(
      '/weights/user/$userId',
      body: {'weight': weight},
    );
    return WeightRecord.fromJson(response);
  }

  Future<void> deleteRecord({
    required int userId,
    required int recordId,
  }) async {
    await _apiService.delete('/weights/user/$userId/$recordId');
  }
}
