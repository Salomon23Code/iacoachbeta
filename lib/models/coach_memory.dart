class CoachMemory {
  final int userId;

  final String currentGoal;

  final List<String> triggers;

  final List<String> victories;

  CoachMemory({
    required this.userId,
    required this.currentGoal,
    this.triggers = const [],
    this.victories = const [],
  });

  factory CoachMemory.fromJson(Map<String, dynamic> json) {
    final userIdValue = json['userId'] ?? json['user_id'];
    return CoachMemory(
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? '') ?? 0,
      currentGoal: (json['currentGoal'] ?? json['current_goal'] ?? '')
          .toString(),
      triggers: (json['triggers'] as List<dynamic>? ?? [])
          .map((value) => value.toString())
          .toList(),
      victories: (json['victories'] as List<dynamic>? ?? [])
          .map((value) => value.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'currentGoal': currentGoal,
    'triggers': triggers,
    'victories': victories,
  };

  CoachMemory copyWith({
    int? userId,
    String? currentGoal,
    List<String>? triggers,
    List<String>? victories,
  }) {
    return CoachMemory(
      userId: userId ?? this.userId,
      currentGoal: currentGoal ?? this.currentGoal,
      triggers: triggers ?? this.triggers,
      victories: victories ?? this.victories,
    );
  }
}
