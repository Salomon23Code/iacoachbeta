import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/coach_response.dart';

import '../services/CoachService.dart';
import '../services/api_service.dart';

class AiProvider extends ChangeNotifier {
  final CoachService _coachService;

  AiProvider({ApiService? apiService})
    : _coachService = CoachService(apiService ?? ApiService());

  final List<ChatMessage> _messages = [];

  int? _conversationId;

  bool _isLoading = false;

  String? _error;

  String? _playbook;

  bool _safetyTriggered = false;

  String? _safetyLevel;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  int? get conversationId => _conversationId;

  bool get isLoading => _isLoading;

  bool get hasUnreadMessage => _messages.isNotEmpty && _error == null;

  String? get error => _error;

  String? get playbook => _playbook;

  bool get safetyTriggered => _safetyTriggered;

  String? get safetyLevel => _safetyLevel;

  Future<void> sendMessage({
    required int userId,
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      return;
    }

    _error = null;

    /*
     * Ajouter immédiatement le message
     * de l'utilisateur à l'écran.
     */
    _messages.add(
      ChatMessage(
        userId: userId,
        sender: MessageSender.user,
        message: message.trim(),
      ),
    );

    _isLoading = true;

    notifyListeners();

    try {
      final CoachResponse response = await _coachService.sendMessage(
        userId: userId,
        message: message.trim(),
        conversationId: _conversationId,
      );

      /*
       * Le backend peut créer une nouvelle conversation.
       */
      if (response.conversationId != null) {
        _conversationId = response.conversationId;
      }

      _playbook = response.playbook;

      _safetyTriggered = response.safetyTriggered;

      _safetyLevel = response.safetyLevel;

      /*
       * Ajouter la réponse de NEO.
       */
      _messages.add(
        ChatMessage(
          userId: userId,
          conversationId: _conversationId,
          sender: MessageSender.coach,
          message: response.message,
          detectedPlaybook: response.playbook,
          safetyTriggered: response.safetyTriggered,
          safetyLevel: response.safetyLevel,
        ),
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Impossible de contacter le Coach NEO.';
    }

    _isLoading = false;

    notifyListeners();
  }

  void startNewConversation() {
    clearConversation();
  }

  void clearConversation() {
    _messages.clear();

    _conversationId = null;

    _error = null;

    _playbook = null;

    _safetyTriggered = false;

    _safetyLevel = null;

    _isLoading = false;

    notifyListeners();
  }

  void clearError() {
    _error = null;

    notifyListeners();
  }
}
