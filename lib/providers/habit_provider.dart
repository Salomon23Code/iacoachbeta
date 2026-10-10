import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../services/api_service.dart';
import '../services/habit_service.dart';

class HabitProvider extends ChangeNotifier {
  final HabitService _service;

  HabitProvider({required ApiService apiService})
    : _service = HabitService(apiService);

  final List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;

  List<Habit> get habits => List.unmodifiable(_habits);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadHabits(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final habits = await _service.getHabits(userId);
      _habits
        ..clear()
        ..addAll(habits);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Habit> get completedHabits {
    return _habits.where((habit) => habit.completed).toList();
  }

  List<Habit> get todayHabits {
    final now = DateTime.now();

    return _habits.where((habit) {
      return habit.date.year == now.year &&
          habit.date.month == now.month &&
          habit.date.day == now.day;
    }).toList();
  }

  int get currentStreak {
    if (_habits.isEmpty) return 0;

    final completedDays = <DateTime>{};

    for (final habit in _habits) {
      if (habit.completed) {
        final date = DateTime(
          habit.date.year,
          habit.date.month,
          habit.date.day,
        );

        completedDays.add(date);
      }
    }

    int streak = 0;
    DateTime day = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    while (completedDays.contains(day)) {
      streak++;

      day = day.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<bool> addHabit({
    required int userId,
    required String title,
    required String description,
    DateTime? date,
  }) async {
    _error = null;
    try {
      final habit = await _service.createHabit(
        userId: userId,
        title: title,
        description: description,
      );
      _habits.insert(0, habit);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleHabit(int habitId) async {
    final index = _habits.indexWhere((habit) => habit.id == habitId);

    if (index == -1) return false;
    if (_habits[index].completed) return true;

    _error = null;
    try {
      final updatedHabit = await _service.completeHabit(
        userId: _habits[index].userId,
        habitId: habitId,
      );
      _habits[index] = updatedHabit;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteHabit(int habitId) async {
    _error = null;
    try {
      final index = _habits.indexWhere((habit) => habit.id == habitId);
      if (index == -1) return false;
      await _service.deleteHabit(
        userId: _habits[index].userId,
        habitId: habitId,
      );
      _habits.removeWhere((habit) => habit.id == habitId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void loadDemoHabit(int userId) {
    _habits.clear();

    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));

      _habits.add(
        Habit(
          id: i + 1,
          userId: userId,
          title: 'Marcher 10 minutes',
          description: 'Marcher 10 minutes après le travail',
          completed: i < 4,
          date: date,
        ),
      );
    }

    notifyListeners();
  }

  void clear() {
    _habits.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
