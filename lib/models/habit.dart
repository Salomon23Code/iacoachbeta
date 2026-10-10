class Habit {
  final int id;
  final int userId;
  final String title;
  final String description;
  final bool completed;
  final int completedCount;
  final bool active;
  final DateTime date;

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.completed,
    this.completedCount = 0,
    this.active = true,
    required this.date,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final userIdValue = json['userId'] ?? json['user_id'];
    final dateValue = json['startedAt'] ?? json['date'] ?? json['createdAt'];
    final countValue = json['completedCount'];
    final completedCount = countValue is num
        ? countValue.toInt()
        : int.tryParse(countValue?.toString() ?? '') ?? 0;

    return Habit(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? '') ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      completed: json['completed'] == true || completedCount > 0,
      completedCount: completedCount,
      active: json['active'] != false,
      date: DateTime.tryParse(dateValue?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'completed': completed,
      'completedCount': completedCount,
      'active': active,
      'date': date.toIso8601String(),
    };
  }

  Habit copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? completed,
    int? completedCount,
    bool? active,
    DateTime? date,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      completedCount: completedCount ?? this.completedCount,
      active: active ?? this.active,
      date: date ?? this.date,
    );
  }
}
