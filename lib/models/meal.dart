enum MealType { breakfast, lunch, dinner, snack }

class Meal {
  final int id;
  final MealType type;
  final String description;
  final String? imagePath;
  final double calories;
  final DateTime date;

  Meal({
    required this.id,
    required this.type,
    required this.description,
    this.imagePath,
    required this.calories,
    required this.date,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString().toLowerCase();
    final parsedType = switch (rawType) {
      'breakfast' => MealType.breakfast,
      'lunch' => MealType.lunch,
      'dinner' => MealType.dinner,
      'snack' => MealType.snack,
      _ => MealType.breakfast,
    };

    return Meal(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      type: parsedType,
      description: json['description']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? json['photoUrl']?.toString(),
      calories: json['calories'] is num
          ? (json['calories'] as num).toDouble()
          : 0.0,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'imagePath': imagePath,
      'calories': calories,
      'date': date.toIso8601String(),
    };
  }

  String get typeLabel {
    switch (type) {
      case MealType.breakfast:
        return 'Petit déjeuner';

      case MealType.lunch:
        return 'Déjeuner';

      case MealType.dinner:
        return 'Dîner';

      case MealType.snack:
        return 'Collation';
    }
  }
}
