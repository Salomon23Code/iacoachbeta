import 'package:flutter/foundation.dart';

import '../models/delais_action.dart';
import '../services/api_service.dart';
import '../services/daily_actions_service.dart';

class DailyActionProvider extends ChangeNotifier {
  final DailyActionService _service;

  DailyActionProvider({required ApiService apiService})
    : _service = DailyActionService(apiService);

  List<DailyAction> _actions = [];
  DailyAction? _currentAction;

  bool _isLoading = false;

  String? _error;

  List<DailyAction> get actions => List.unmodifiable(_actions);

  DailyAction? get currentAction {
    if (_currentAction != null) return _currentAction;

    for (final action in _actions) {
      if (!action.committed && !action.completed) return action;
    }

    return null;
  }

  List<DailyAction> get committedActions =>
      List.unmodifiable(_actions.where((action) => action.committed));

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadActions(int userId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _actions = (await _service.getActions(
        userId,
      )).whereType<Map<String, dynamic>>().map(DailyAction.fromJson).toList();
      _currentAction = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> createAction({
    required int userId,
    required String action,
    required String trigger,
    required String tracking,
    String? description,
  }) async {
    try {
      final result = await _service.createAction(
        userId: userId,
        action: action,
        trigger: trigger,
        tracking: tracking,
        description: description,
      );

      final createdAction = DailyAction.fromJson(result);
      _actions.insert(0, createdAction);
      _currentAction = createdAction;

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<bool> completeAction({
    required int userId,
    required int actionId,
  }) async {
    try {
      final result = await _service.completeAction(
        userId: userId,
        actionId: actionId,
      );

      final index = _actions.indexWhere((action) => action.id == actionId);

      if (index != -1) {
        final completedAction = DailyAction.fromJson(result);
        _actions[index] = completedAction;
        if (_currentAction?.id == actionId) _currentAction = null;
      }

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<bool> generateAction({required int userId, String? reason}) {
    return createAction(
      userId: userId,
      action: 'Marcher 10 minutes',
      description: reason?.trim().isNotEmpty == true
          ? 'Une action simple pour avancer malgré : ${reason!.trim()}'
          : 'Une courte marche est un bon début pour aujourd’hui.',
      trigger: 'Après un moment de pause',
      tracking: 'Noter comment vous vous sentez après',
    );
  }

  Future<bool> commitAction({required int userId}) async {
    final action = currentAction;
    if (action == null) return false;
    if (action.committed) return true;

    _error = null;
    try {
      final result = await _service.commitAction(
        userId: userId,
        actionId: action.id,
      );
      _replaceAction(action.id, DailyAction.fromJson(result));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCurrentAction({required int userId}) async {
    final action = currentAction;
    if (action == null) return true;

    _error = null;
    try {
      if (action.committed) {
        final result = await _service.completeAction(
          userId: userId,
          actionId: action.id,
        );
        _replaceAction(action.id, DailyAction.fromJson(result));
        _currentAction = null;
      } else {
        await _service.deleteAction(userId: userId, actionId: action.id);
        _actions.removeWhere((item) => item.id == action.id);
        _currentAction = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _replaceAction(int actionId, DailyAction updatedAction) {
    final index = _actions.indexWhere((action) => action.id == actionId);
    if (index == -1) {
      _actions.insert(0, updatedAction);
    } else {
      _actions[index] = updatedAction;
    }
    if (_currentAction?.id == actionId) _currentAction = updatedAction;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
