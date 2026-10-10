/*class DailyAction {
  final int id;
  final String title;
  final String description;
  final String trigger;
  final String tracking;
  final DateTime createdAt;
  bool committed;
  bool completed;

  DailyAction({
    required this.id,
    required this.title,
    required this.description,
    required this.trigger,
    required this.tracking,
    required this.createdAt,
    this.committed = false,
    this.completed = false,
  });

  DailyAction copyWith({
    String? title,
    String? description,
    String? trigger,
    String? tracking,
    bool? committed,
    bool? completed,
  }) {
    return DailyAction(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      trigger: trigger ?? this.trigger,
      tracking: tracking ?? this.tracking,
      createdAt: createdAt,
      committed: committed ?? this.committed,
      completed: completed ?? this.completed,
    );
  }
}*/

class DailyAction {
  final int id;

  final String title;
  final String description;

  /// Déclencheur de l'action
  final String trigger;

  /// Moment ou méthode de suivi
  final String tracking;

  final DateTime createdAt;

  bool committed;
  bool completed;

  DailyAction({
    required this.id,
    required this.title,
    required this.description,
    required this.trigger,
    required this.tracking,
    required this.createdAt,
    this.committed = false,
    this.completed = false,
  });

  factory DailyAction.fromJson(Map<String, dynamic> json) {
    final actionText = (json['action'] ?? json['title'] ?? '').toString();
    final idValue = json['id'];
    final createdAtValue = json['createdAt'] ?? json['created_at'];

    return DailyAction(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ??
                DateTime.now().millisecondsSinceEpoch,
      title: actionText,
      description: (json['description'] ?? actionText).toString(),
      trigger: (json['trigger'] ?? '').toString(),
      tracking: (json['tracking'] ?? '').toString(),
      createdAt:
          DateTime.tryParse(createdAtValue?.toString() ?? '') ?? DateTime.now(),
      committed: json['committed'] == true || json['isCommitted'] == true,
      completed: json['completed'] == true || json['isCompleted'] == true,
    );
  }

  DailyAction copyWith({
    String? title,
    String? description,
    String? trigger,
    String? tracking,
    bool? committed,
    bool? completed,
  }) {
    return DailyAction(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      trigger: trigger ?? this.trigger,
      tracking: tracking ?? this.tracking,
      createdAt: createdAt,
      committed: committed ?? this.committed,
      completed: completed ?? this.completed,
    );
  }
}
