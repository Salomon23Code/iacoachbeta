import 'api_service.dart';

class ConversationService {
  final ApiService _apiService;

  ConversationService(this._apiService);

  Future<Map<String, dynamic>> getConversation({
    required int conversationId,
    required int userId,
  }) async {
    return _apiService.get('/ai/conversations/$conversationId?userId=$userId');
  }

  Future<List<dynamic>> getConversations({required int userId}) async {
    final response = await _apiService.get('/ai/conversations?userId=$userId');

    return response['data'] as List<dynamic>? ?? [];
  }

  Future<void> archiveConversation({
    required int conversationId,
    required int userId,
  }) async {
    await _apiService.patch(
      '/ai/conversations/$conversationId/archive?userId=$userId',
    );
  }
}
