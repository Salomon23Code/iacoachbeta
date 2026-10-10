import 'life_challenge.dart';

enum AddressingStyle { tu, vous }

class CoachingProfile {
  final int id;
  final int userId;

  final AddressingStyle addressingStyle;

  final int age;
  final double height;
  final double currentWeight;
  final String country;

  final double targetWeight;
  final String motivation;

  final List<LifeChallenge> challenges;

  final String otherChallenge;

  CoachingProfile({
    required this.id,
    required this.userId,
    required this.addressingStyle,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.country,
    required this.targetWeight,
    required this.motivation,
    required this.challenges,
    required this.otherChallenge,
  });

  factory CoachingProfile.fromJson(Map<String, dynamic> json) {
    final addressingValue =
        (json['addressingStyle'] ?? json['addressing_style'])?.toString();
    final addressingStyle = addressingValue?.toUpperCase() == 'VOUS'
        ? AddressingStyle.vous
        : AddressingStyle.tu;
    final challengesValue = json['challenges'];
    final challenges = challengesValue is List
        ? challengesValue
              .whereType<Map<String, dynamic>>()
              .map(LifeChallenge.fromJson)
              .toList()
        : <LifeChallenge>[];
    double asDouble(dynamic value) => value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;
    int asInt(dynamic value) =>
        value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

    return CoachingProfile(
      id: asInt(json['id']),
      userId: asInt(json['userId'] ?? json['user_id']),
      addressingStyle: addressingStyle,
      age: asInt(json['age']),
      height: asDouble(json['height']),
      currentWeight: asDouble(json['currentWeight'] ?? json['current_weight']),
      country: (json['country'] ?? '').toString(),
      targetWeight: asDouble(json['targetWeight'] ?? json['target_weight']),
      motivation: (json['motivation'] ?? '').toString(),
      challenges: challenges,
      otherChallenge: (json['otherChallenge'] ?? json['other_challenge'] ?? '')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'addressingStyle': addressingStyle.name,
    'age': age,
    'height': height,
    'currentWeight': currentWeight,
    'country': country,
    'targetWeight': targetWeight,
    'motivation': motivation,
    'challenges': challenges.map((challenge) => challenge.toJson()).toList(),
    'otherChallenge': otherChallenge,
  };

  String get addressingLabel {
    switch (addressingStyle) {
      case AddressingStyle.tu:
        return 'Tu';

      case AddressingStyle.vous:
        return 'Vous';
    }
  }
}
