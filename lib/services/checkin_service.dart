import 'api_service.dart';
import '../models/daily_checking.dart';

class CheckInService {
  final ApiService _apiService;

  CheckInService(this._apiService);

  Future<List<dynamic>> getCheckIns(int userId) async {
    final response = await _apiService.get('/checkins/user/$userId');

    return response['data'] as List<dynamic>? ?? [];
  }

  Future<Map<String, dynamic>> createCheckIn({
    required int userId,
    required CheckInStatus status,
    String? reason,
  }) async {
    return _apiService.post(
      '/checkins/user/$userId',
      body: {'status': status.name, if (reason != null) 'reason': reason},
    );
  }
}
