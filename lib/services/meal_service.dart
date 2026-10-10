import '../models/meal.dart';
import 'api_service.dart';

class MealService {
  final ApiService _apiService;

  MealService(this._apiService);

  Future<List<Meal>> getMeals(int userId) async {
    final response = await _apiService.get('/meals/user/$userId');

    final data = response['data'];

    if (data is List) {
      return data
          .map((json) => Meal.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  Future<Meal> createMeal({
    required int userId,
    required String type,
    required String description,
    required double calories,
    String? photoUrl,
  }) async {
    final response = await _apiService.post(
      '/meals',
      body: {
        'userId': userId,
        'type': type,
        'description': description,
        'calories': calories,
        if (photoUrl != null) 'photoUrl': photoUrl,
      },
    );

    return Meal.fromJson(response);
  }

  Future<void> deleteMeal({required int userId, required int mealId}) async {
    await _apiService.delete('/meals/user/$userId/$mealId');
  }
}
