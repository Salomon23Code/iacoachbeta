import '../models/shopping_items.dart';
import 'api_service.dart';

class ShoppingService {
  final ApiService _apiService;

  ShoppingService(this._apiService);

  Future<List<ShoppingItem>> getItems(int userId) async {
    final response = await _apiService.get('/shopping/user/$userId');
    final data = response['data'];
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(ShoppingItem.fromJson)
        .toList();
  }

  Future<ShoppingItem> createItem({
    required int userId,
    required String name,
    required ShoppingCategory category,
  }) async {
    final response = await _apiService.post(
      '/shopping/user/$userId',
      body: {'name': name, 'category': category.name},
    );
    return ShoppingItem.fromJson(response);
  }

  Future<ShoppingItem> updateItem({
    required int userId,
    required ShoppingItem item,
  }) async {
    if (item.id == null) return item;
    final response = await _apiService.put(
      '/shopping/user/$userId/${item.id}',
      body: {
        'name': item.name,
        'category': item.category.name,
        'checked': item.checked,
      },
    );
    return ShoppingItem.fromJson(response);
  }

  Future<void> deleteItem({required int userId, required int itemId}) async {
    await _apiService.delete('/shopping/user/$userId/$itemId');
  }
}
