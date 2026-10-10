import '../models/chat_message.dart';
import '../models/coach_response.dart';
import 'api_service.dart';

class CoachService {
  final ApiService _apiService;

  CoachService(this._apiService);

  Future<CoachResponse> sendMessage({
    required int userId,
    required String message,
    int? conversationId,
  }) async {
    final body = <String, dynamic>{'userId': userId, 'message': message};

    if (conversationId != null) {
      body['conversationId'] = conversationId;
    }

    final response = await _apiService.post('/ai/coach', body: body);

    return CoachResponse.fromJson(response);
  }
}
