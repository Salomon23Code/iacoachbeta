import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import '../services/conversation_service.dart';

class ConversationProvider extends ChangeNotifier {
  final ConversationService _service;

  ConversationProvider({
    required ApiService apiService,
  }) : _service = ConversationService(apiService);

  List<dynamic> _conversations = [];

  Map<String, dynamic>? _currentConversation;

  bool _isLoading = false;

  String? _error;

  List<dynamic> get conversations =>
      List.unmodifiable(_conversations);

  Map<String, dynamic>? get currentConversation =>
      _currentConversation;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadConversations(
      int userId,
      ) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _conversations =
      await _service.getConversations(
        userId: userId,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> loadConversation({
    required int conversationId,
    required int userId,
  }) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _currentConversation =
      await _service.getConversation(
        conversationId: conversationId,
        userId: userId,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> archiveConversation({
    required int conversationId,
    required int userId,
  }) async {
    try {
      await _service.archiveConversation(
        conversationId: conversationId,
        userId: userId,
      );

      await loadConversations(userId);

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  void clearCurrentConversation() {
    _currentConversation = null;
    notifyListeners();
  }
}