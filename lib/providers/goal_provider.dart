import 'package:flutter/foundation.dart';

import '../models/goal.dart';
import '../services/api_service.dart';
import '../services/goal_service.dart';
import '../services/parcours_services.dart';

class GoalProvider extends ParcoursProvider {
  GoalProvider({ApiService? apiService})
    : _goalService = GoalService(apiService ?? ApiService()),
      super(apiService: apiService ?? ApiService());

  final GoalService _goalService;

  List<Goal> _goalHistory = [];

  List<Goal> get goalHistory => List.unmodifiable(_goalHistory);

  Future<void> loadGoal(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _goal = await _goalService.getActiveGoal(userId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadGoalHistory(int userId) async {
    try {
      _goalHistory = await _goalService.getHistory(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createGoal({
    required int userId,
    required double targetWeight,
    required String objective,
    required String motivation,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _goal = _goal != null && _goal!.userId == userId && _goal!.id != 0
          ? await _goalService.updateGoal(
              userId: userId,
              goalId: _goal!.id,
              targetWeight: targetWeight,
              objective: objective,
              motivation: motivation,
            )
          : await _goalService.createGoal(
              userId: userId,
              targetWeight: targetWeight,
              objective: objective,
              motivation: motivation,
            );
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

  @override
  Future<bool> updateGoal({
    required int userId,
    required String mainGoal,
    required double targetWeight,
    required String motivation,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _goal = _goal == null || _goal!.id == 0
          ? await _goalService.createGoal(
              userId: userId,
              targetWeight: targetWeight,
              objective: mainGoal,
              motivation: motivation,
            )
          : await _goalService.updateGoal(
              userId: userId,
              goalId: _goal!.id,
              targetWeight: targetWeight,
              objective: mainGoal,
              motivation: motivation,
            );
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
}

class ParcoursProvider extends ChangeNotifier {
  final ParcoursService _service;

  ParcoursProvider({required ApiService apiService})
    : _service = ParcoursService(apiService);

  Map<String, dynamic>? _parcours;
  Goal? _goal;

  bool _isLoading = false;

  String? _error;

  Map<String, dynamic>? get parcours => _parcours;

  Goal? get goal => _goal;

  double? get targetWeight =>
      _goal?.targetWeight ??
      (_parcours == null
          ? null
          : (_parcours!['targetWeight'] is num
                ? (_parcours!['targetWeight'] as num).toDouble()
                : null));

  String? get motivation =>
      _goal?.motivation ?? _parcours?['motivation']?.toString();

  String? get mainGoal =>
      _goal?.objective ?? _parcours?['mainGoal']?.toString();

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get hasParcours => _parcours != null;

  Future<void> loadParcours(int userId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _parcours = await _service.getParcours(userId);

      final target = _parcours?['targetWeight'];
      final currentWeight = _parcours?['initialWeight'] ?? 0.0;
      final motivationText = _parcours?['motivation']?.toString() ?? '';

      if (target is num) {
        _goal = Goal(
          id: 0,
          userId: userId,
          currentWeight: currentWeight is num ? currentWeight.toDouble() : 0.0,
          targetWeight: target.toDouble(),
          motivation: motivationText,
          startDate: DateTime.now(),
          objective: _parcours?['mainGoal']?.toString() ?? '',
        );
      } else {
        _goal = null;
      }
    } catch (e) {
      _error = e.toString();
      _goal = null;
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> createParcours({
    required int userId,
    required String mainGoal,
    required double initialWeight,
    required double targetWeight,
    required String motivation,
  }) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _parcours = await _service.createParcours(
        userId: userId,
        mainGoal: mainGoal,
        initialWeight: initialWeight,
        targetWeight: targetWeight,
        motivation: motivation,
      );

      _goal = Goal(
        id: 0,
        userId: userId,
        currentWeight: initialWeight,
        targetWeight: targetWeight,
        motivation: motivation,
        startDate: DateTime.now(),
        objective: mainGoal,
      );

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

  Future<bool> updateGoal({
    required int userId,
    required String mainGoal,
    required double targetWeight,
    required String motivation,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _parcours = await _service.updateGoal(
        userId: userId,
        mainGoal: mainGoal,
        targetWeight: targetWeight,
        motivation: motivation,
      );
      _goal = Goal(
        id: _goal?.id ?? 0,
        userId: userId,
        currentWeight: _goal?.currentWeight ?? 0,
        targetWeight: targetWeight,
        motivation: motivation,
        startDate: _goal?.startDate ?? DateTime.now(),
        objective: mainGoal,
      );

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePhase({required int userId, required String phase}) async {
    try {
      _parcours = await _service.updatePhase(userId: userId, phase: phase);

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteParcours(int userId) async {
    try {
      await _service.deleteParcours(userId);

      _parcours = null;

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
