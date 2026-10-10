enum LifeChallengeType {
  professionalMeals,
  frequentTravel,
  stress,
  littleTime,
  irregularSleep,
  other,
}

class LifeChallenge {
  final LifeChallengeType type;
  final String? description;
  bool selected;

  LifeChallenge({required this.type, this.description, this.selected = false});

  factory LifeChallenge.fromJson(Map<String, dynamic> json) {
    final typeName = (json['type'] ?? '').toString().toUpperCase();
    final type = switch (typeName) {
      'PROFESSIONAL_MEALS' ||
      'PROFESSIONALMEALS' => LifeChallengeType.professionalMeals,
      'FREQUENT_TRAVEL' || 'FREQUENTTRAVEL' => LifeChallengeType.frequentTravel,
      'STRESS' => LifeChallengeType.stress,
      'LITTLE_TIME' || 'LITTLE TIME' => LifeChallengeType.littleTime,
      'IRREGULAR_SLEEP' || 'IRREGULARSLEEP' => LifeChallengeType.irregularSleep,
      _ => LifeChallengeType.other,
    };

    return LifeChallenge(
      type: type,
      description: json['description']?.toString(),
      selected: json['selected'] == true,
    );
  }

  String get apiType => switch (type) {
    LifeChallengeType.professionalMeals => 'PROFESSIONAL_MEALS',
    LifeChallengeType.frequentTravel => 'FREQUENT_TRAVEL',
    LifeChallengeType.stress => 'STRESS',
    LifeChallengeType.littleTime => 'LITTLE_TIME',
    LifeChallengeType.irregularSleep => 'IRREGULAR_SLEEP',
    LifeChallengeType.other => 'OTHER',
  };

  Map<String, dynamic> toJson() => {
    'type': apiType,
    'description': description,
    'selected': selected,
  };

  String get label {
    switch (type) {
      case LifeChallengeType.professionalMeals:
        return 'Repas professionnels';

      case LifeChallengeType.frequentTravel:
        return 'Déplacements fréquents';

      case LifeChallengeType.stress:
        return 'Stress';

      case LifeChallengeType.littleTime:
        return 'Peu de temps';

      case LifeChallengeType.irregularSleep:
        return 'Sommeil irrégulier';
      case LifeChallengeType.other: // 👈 Ajoutez ce cas pour le label
        return 'Autre défi';
    }
  }
}
