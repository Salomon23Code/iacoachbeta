import 'package:flutter/foundation.dart';

import '../models/coach_memory.dart';
import '../services/api_service.dart';
import '../services/coach_memory_service.dart';

class CoachMemoryProvider extends ChangeNotifier {
  final CoachMemoryService _service;

  CoachMemoryProvider({required ApiService apiService})
    : _service = CoachMemoryService(apiService);

  CoachMemory? _memory;
  bool _isLoading = false;
  String? _error;

  CoachMemory? get memory => _memory;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadMemory(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _memory = await _service.getMemory(userId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  String get currentGoal {
    return _memory?.currentGoal ?? '';
  }

  List<String> get triggers {
    return List.unmodifiable(_memory?.triggers ?? []);
  }

  List<String> get victories {
    return List.unmodifiable(_memory?.victories ?? []);
  }

  Future<bool> createMemory({
    required int userId,
    required String currentGoal,
    List<String> triggers = const [],
    List<String> victories = const [],
  }) async {
    _memory = CoachMemory(
      userId: userId,
      currentGoal: currentGoal,
      triggers: triggers,
      victories: victories,
    );

    return _saveMemory();
  }

  Future<bool> updateGoal(String goal) async {
    if (_memory == null) return false;

    _memory = _memory!.copyWith(currentGoal: goal);

    return _saveMemory();
  }

  Future<bool> addTrigger(String trigger) async {
    if (_memory == null) return false;

    final updatedTriggers = [..._memory!.triggers, trigger];

    _memory = _memory!.copyWith(triggers: updatedTriggers);

    return _saveMemory();
  }

  Future<bool> removeTrigger(String trigger) async {
    if (_memory == null) return false;

    final updatedTriggers = List<String>.from(_memory!.triggers)
      ..remove(trigger);

    _memory = _memory!.copyWith(triggers: updatedTriggers);

    return _saveMemory();
  }

  Future<bool> addVictory(String victory) async {
    if (_memory == null) return false;

    final updatedVictories = [..._memory!.victories, victory];

    _memory = _memory!.copyWith(victories: updatedVictories);

    return _saveMemory();
  }

  Future<bool> removeVictory(String victory) async {
    if (_memory == null) return false;

    final updatedVictories = List<String>.from(_memory!.victories)
      ..remove(victory);

    _memory = _memory!.copyWith(victories: updatedVictories);

    return _saveMemory();
  }

  Future<bool> _saveMemory() async {
    final memory = _memory;
    if (memory == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _memory = await _service.saveMemory(memory);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMemory(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.deleteMemory(userId);
      _memory = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _memory = null;
    notifyListeners();
  }
}
