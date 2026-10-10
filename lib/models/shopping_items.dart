enum ShoppingCategory { proteins, vegetables, essentials }

class ShoppingItem {
  final int? id;
  final int? userId;
  final String name;
  final ShoppingCategory category;
  bool checked;

  ShoppingItem({
    this.id,
    this.userId,
    required this.name,
    required this.category,
    this.checked = false,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    final categoryValue = json['category']?.toString().toLowerCase();
    final category = switch (categoryValue) {
      'proteins' || 'protein' => ShoppingCategory.proteins,
      'vegetables' || 'vegetable' => ShoppingCategory.vegetables,
      _ => ShoppingCategory.essentials,
    };
    final idValue = json['id'];
    final userIdValue = json['userId'] ?? json['user_id'];

    return ShoppingItem(
      id: idValue is int ? idValue : int.tryParse(idValue?.toString() ?? ''),
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? ''),
      name: (json['name'] ?? '').toString(),
      category: category,
      checked: json['checked'] == true || json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (userId != null) 'userId': userId,
    'name': name,
    'category': category.name,
    'checked': checked,
  };
}
