import '../models/coach_memory.dart';
import 'api_service.dart';

class CoachMemoryService {
  final ApiService _apiService;

  CoachMemoryService(this._apiService);

  Future<CoachMemory?> getMemory(int userId) async {
    final response = await _apiService.get('/coach-memory/user/$userId');
    final data = response['data'];
    if (data is Map<String, dynamic>) return CoachMemory.fromJson(data);
    if (response.containsKey('userId') || response.containsKey('user_id')) {
      return CoachMemory.fromJson(response);
    }
    return null;
  }

  Future<CoachMemory> saveMemory(CoachMemory memory) async {
    final response = await _apiService.put(
      '/coach-memory/user/${memory.userId}',
      body: memory.toJson(),
    );
    final data = response['data'];
    return CoachMemory.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<void> deleteMemory(int userId) async {
    await _apiService.delete('/coach-memory/user/$userId');
  }
}
