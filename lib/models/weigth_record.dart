class WeightRecord {
  final int id;
  final int userId;
  final double weight;
  final DateTime date;

  WeightRecord({
    required this.id,
    required this.userId,
    required this.weight,
    required this.date,
  });

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final userIdValue = json['userId'] ?? json['user_id'];
    final weightValue = json['weight'];
    final dateValue =
        json['recordedAt'] ??
        json['date'] ??
        json['createdAt'] ??
        json['created_at'];

    return WeightRecord(
      id: idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0,
      userId: userIdValue is int
          ? userIdValue
          : int.tryParse(userIdValue?.toString() ?? '') ?? 0,
      weight: weightValue is num
          ? weightValue.toDouble()
          : double.tryParse(weightValue?.toString() ?? '') ?? 0,
      date: DateTime.tryParse(dateValue?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'weight': weight,
    'date': date.toIso8601String(),
  };

  WeightRecord copyWith({
    int? id,
    int? userId,
    double? weight,
    DateTime? date,
  }) {
    return WeightRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      date: date ?? this.date,
    );
  }
}
