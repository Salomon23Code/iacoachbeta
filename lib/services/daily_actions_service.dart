import 'api_service.dart';

class DailyActionService {
  final ApiService _apiService;

  DailyActionService(this._apiService);

  Future<List<dynamic>> getActions(int userId) async {
    final response = await _apiService.get('/commitments/user/$userId');

    return response['data'] as List<dynamic>? ?? [];
  }

  Future<Map<String, dynamic>> createAction({
    required int userId,
    required String action,
    required String trigger,
    required String tracking,
    String? description,
  }) async {
    return _apiService.post(
      '/commitments/user/$userId',
      body: {
        'title': action,
        if (description != null) 'description': description,
        'trigger': trigger,
        'tracking': tracking,
      },
    );
  }

  Future<Map<String, dynamic>> commitAction({
    required int userId,
    required int actionId,
  }) async {
    return _apiService.post('/commitments/user/$userId/$actionId/commit');
  }

  Future<Map<String, dynamic>> completeAction({
    required int userId,
    required int actionId,
  }) async {
    return _apiService.post('/commitments/user/$userId/$actionId/complete');
  }

  Future<void> deleteAction({
    required int userId,
    required int actionId,
  }) async {
    await _apiService.delete('/commitments/user/$userId/$actionId');
  }
}
