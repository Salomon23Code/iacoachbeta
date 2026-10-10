enum CheckInStatus {
  yes,
  partially,
  no,
}

class DailyCheckIn {
  final int id;
  final int userId;
  final DateTime date;
  final CheckInStatus status;
  final String reason;

  DailyCheckIn({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.reason,
  });

  String get statusLabel {
    switch (status) {
      case CheckInStatus.yes:
        return 'Oui';

      case CheckInStatus.partially:
        return 'En partie';

      case CheckInStatus.no:
        return 'Non';
    }
  }

  DailyCheckIn copyWith({
    int? id,
    int? userId,
    DateTime? date,
    CheckInStatus? status,
    String? reason,
  }) {
    return DailyCheckIn(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }
}