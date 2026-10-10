import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/meal_service.dart';

class MealProvider extends ChangeNotifier {
  final MealService _service;

  MealProvider({required ApiService apiService})
    : _service = MealService(apiService);

  final List<Meal> _meals = [];

  bool _isLoading = false;

  String? _error;

  List<Meal> get meals => List.unmodifiable(_meals);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadMeals(int userId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final meals = await _service.getMeals(userId);

      _meals
        ..clear()
        ..addAll(meals);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> addMeal({
    required int userId,
    required MealType type,
    required String description,
    required double calories,
    String? imagePath,
  }) async {
    try {
      final meal = await _service.createMeal(
        userId: userId,
        type: type.name,
        description: description,
        calories: calories,
        photoUrl: imagePath,
      );

      _meals.insert(0, meal);

      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      return false;
    }
  }

  Future<bool> deleteMeal({required int userId, required int mealId}) async {
    try {
      await _service.deleteMeal(userId: userId, mealId: mealId);

      _meals.removeWhere((meal) => meal.id == mealId);

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

  void clear() {
    _meals.clear();
    notifyListeners();
  }
}
