import '../models/habit.dart';
import 'api_service.dart';

class HabitService {
  final ApiService _apiService;

  HabitService(this._apiService);

  Future<List<Habit>> getHabits(int userId) async {
    final response = await _apiService.get('/habits/user/$userId/active');
    final data = response['data'];

    if (data is! List) return [];

    return data.whereType<Map<String, dynamic>>().map(Habit.fromJson).toList();
  }

  Future<Habit> createHabit({
    required int userId,
    required String title,
    required String description,
  }) async {
    final response = await _apiService.post(
      '/habits/user/$userId',
      body: {'title': title, 'description': description},
    );

    return Habit.fromJson(response);
  }

  Future<Habit> updateHabit({required int userId, required Habit habit}) async {
    final response = await _apiService.put(
      '/habits/user/$userId/${habit.id}',
      body: {'title': habit.title, 'description': habit.description},
    );

    return Habit.fromJson(response);
  }

  Future<Habit> completeHabit({
    required int userId,
    required int habitId,
  }) async {
    final response = await _apiService.post(
      '/habits/user/$userId/$habitId/complete',
    );
    return Habit.fromJson(response);
  }

  Future<void> deleteHabit({required int userId, required int habitId}) async {
    await _apiService.delete('/habits/user/$userId/$habitId');
  }
}
