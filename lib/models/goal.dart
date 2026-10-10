class Goal {
  final int id;
  final int userId;
  final double currentWeight;
  final double targetWeight;
  final String motivation;
  final DateTime startDate;
  final String objective;
  final bool active;

  Goal({
    required this.id,
    required this.userId,
    required this.currentWeight,
    required this.targetWeight,
    required this.motivation,
    required this.startDate,
    this.objective = '',
    this.active = true,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final userIdValue = json['userId'] ?? json['user_id'];
    final targetValue = json['targetWeight'] ?? json['target_weight'];
    final createdValue = json['createdAt'] ?? json['created_at'];
    double asDouble(dynamic value) => value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;

    return Goal(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? '') ?? 0,
      currentWeight: asDouble(json['currentWeight'] ?? json['current_weight']),
      targetWeight: asDouble(targetValue),
      motivation: (json['motivation'] ?? '').toString(),
      startDate:
          DateTime.tryParse(createdValue?.toString() ?? '') ?? DateTime.now(),
      objective: (json['objective'] ?? '').toString(),
      active: json['active'] != false,
    );
  }

  double get weightDifference {
    return currentWeight - targetWeight;
  }

  Goal copyWith({
    int? id,
    int? userId,
    double? currentWeight,
    double? targetWeight,
    String? motivation,
    DateTime? startDate,
    String? objective,
    bool? active,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      motivation: motivation ?? this.motivation,
      startDate: startDate ?? this.startDate,
      objective: objective ?? this.objective,
      active: active ?? this.active,
    );
  }
}
