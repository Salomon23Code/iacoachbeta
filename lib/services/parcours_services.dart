import 'api_service.dart';

class ParcoursService {
  final ApiService _apiService;

  ParcoursService(this._apiService);

  Future<Map<String, dynamic>> getParcours(int userId) async {
    return _apiService.get('/parcours/user/$userId');
  }

  Future<Map<String, dynamic>> createParcours({
    required int userId,
    required String mainGoal,
    required double initialWeight,
    required double targetWeight,
    required String motivation,
  }) async {
    return _apiService.post(
      '/parcours/user/$userId',
      body: {
        'userId': userId,
        'mainGoal': mainGoal,
        'initialWeight': initialWeight,
        'targetWeight': targetWeight,
        'motivation': motivation,
      },
    );
  }

  Future<Map<String, dynamic>> updateGoal({
    required int userId,
    required String mainGoal,
    required double targetWeight,
    required String motivation,
  }) async {
    final query = Uri(
      queryParameters: {
        'mainGoal': mainGoal,
        'targetWeight': targetWeight.toString(),
        'motivation': motivation,
      },
    ).query;
    return _apiService.put('/parcours/user/$userId/goal?$query');
  }

  Future<Map<String, dynamic>> updatePhase({
    required int userId,
    required String phase,
  }) async {
    final query = Uri(queryParameters: {'phase': phase}).query;
    return _apiService.put('/parcours/user/$userId/phase?$query');
  }

  Future<void> deleteParcours(int userId) async {
    await _apiService.delete('/parcours/user/$userId');
  }
}
