import 'package:flutter/material.dart';

import '../models/shopping_items.dart';
import '../services/api_service.dart';
import '../services/shopping_service.dart';

class ShoppingProvider extends ChangeNotifier {
  final ShoppingService _service;

  ShoppingProvider({required ApiService apiService})
    : _service = ShoppingService(apiService);

  final List<ShoppingItem> _items = [
    ShoppingItem(name: 'Poulet', category: ShoppingCategory.proteins),
    ShoppingItem(name: 'Poisson', category: ShoppingCategory.proteins),
    ShoppingItem(name: 'Œufs', category: ShoppingCategory.proteins),
    ShoppingItem(name: 'Yaourt nature', category: ShoppingCategory.proteins),

    ShoppingItem(name: 'Tomate', category: ShoppingCategory.vegetables),
    ShoppingItem(name: 'Salade', category: ShoppingCategory.vegetables),
    ShoppingItem(name: 'Carotte', category: ShoppingCategory.vegetables),
    ShoppingItem(name: 'Haricot vert', category: ShoppingCategory.vegetables),

    ShoppingItem(name: 'Citron', category: ShoppingCategory.essentials),
    ShoppingItem(name: 'Épices', category: ShoppingCategory.essentials),
  ];

  bool _isLoading = false;
  String? _error;

  List<ShoppingItem> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadItems(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var items = await _service.getItems(userId);
      if (items.isEmpty && _items.every((item) => item.id == null)) {
        final defaults = List<ShoppingItem>.from(_items);
        items = [];
        for (final item in defaults) {
          items.add(
            await _service.createItem(
              userId: userId,
              name: item.name,
              category: item.category,
            ),
          );
        }
      }
      _items
        ..clear()
        ..addAll(items);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addItem({
    required int userId,
    required String name,
    required ShoppingCategory category,
  }) async {
    _error = null;
    try {
      final item = await _service.createItem(
        userId: userId,
        name: name,
        category: category,
      );
      _items.add(item);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  List<ShoppingItem> itemsByCategory(ShoppingCategory category) {
    return _items.where((item) => item.category == category).toList();
  }

  Future<bool> toggleItem(ShoppingItem item) async {
    item.checked = !item.checked;
    notifyListeners();

    if (item.id == null) return true;
    try {
      final updated = await _service.updateItem(
        userId: item.userId ?? 0,
        item: item,
      );
      final index = _items.indexWhere((candidate) => candidate.id == item.id);
      if (index != -1) _items[index] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      item.checked = !item.checked;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  int get checkedCount {
    return _items.where((item) => item.checked).length;
  }

  Future<void> clearChecked() async {
    final checkedItems = _items.where((item) => item.checked).toList();
    for (final item in checkedItems) {
      item.checked = false;
    }
    notifyListeners();

    for (final item in checkedItems.where((item) => item.id != null)) {
      try {
        final updated = await _service.updateItem(
          userId: item.userId ?? 0,
          item: item,
        );
        final index = _items.indexWhere((candidate) => candidate.id == item.id);
        if (index != -1) _items[index] = updated;
      } catch (e) {
        _error = e.toString();
      }
    }
    notifyListeners();
  }

  Future<bool> deleteItem({required int userId, required int itemId}) async {
    _error = null;
    try {
      await _service.deleteItem(userId: userId, itemId: itemId);
      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
