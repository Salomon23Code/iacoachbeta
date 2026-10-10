import '../models/goal.dart';
import 'api_service.dart';

class GoalService {
  final ApiService _apiService;

  GoalService(this._apiService);

  Future<Goal> getActiveGoal(int userId) async {
    final response = await _apiService.get('/goals/user/$userId/active');
    final data = response['data'];
    return Goal.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<List<Goal>> getHistory(int userId) async {
    final response = await _apiService.get('/goals/user/$userId');
    final data = response['data'];
    if (data is! List) return [];
    return data.whereType<Map<String, dynamic>>().map(Goal.fromJson).toList();
  }

  Future<Goal> createGoal({
    required int userId,
    required double targetWeight,
    required String objective,
    required String motivation,
  }) async {
    final response = await _apiService.post(
      '/goals/user/$userId',
      body: {
        'targetWeight': targetWeight,
        'objective': objective,
        'motivation': motivation,
      },
    );
    final data = response['data'];
    return Goal.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<Goal> updateGoal({
    required int userId,
    required int goalId,
    required double targetWeight,
    required String objective,
    required String motivation,
  }) async {
    final response = await _apiService.put(
      '/goals/user/$userId/$goalId',
      body: {
        'targetWeight': targetWeight,
        'objective': objective,
        'motivation': motivation,
      },
    );
    final data = response['data'];
    return Goal.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<void> deactivateGoal({
    required int userId,
    required int goalId,
  }) async {
    await _apiService.delete('/goals/user/$userId/$goalId');
  }
}
