import 'package:flutter/material.dart';

import '../models/coaching_profile.dart';
import '../models/life_challenge.dart';
import '../services/api_service.dart';
import '../services/coaching_profile_service.dart';

class CoachingProfileProvider extends ChangeNotifier {
  final CoachingProfileService _service;

  CoachingProfileProvider({required ApiService apiService})
    : _service = CoachingProfileService(apiService);

  CoachingProfile? _profile;
  bool _isLoading = false;
  String? _error;

  CoachingProfile? get profile => _profile;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadProfile(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.getProfile(userId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // --------------------------------------------------
  // ÉTAPE 1 : façon de s'adresser à l'utilisateur
  // --------------------------------------------------

  AddressingStyle? _addressingStyle;

  AddressingStyle? get addressingStyle => _addressingStyle;

  // --------------------------------------------------
  // ÉTAPE 2 : informations personnelles
  // --------------------------------------------------

  int? _age;
  double? _height;
  double? _currentWeight;
  String? _country;

  int? get age => _age;
  double? get height => _height;
  double? get currentWeight => _currentWeight;
  String? get country => _country;

  // --------------------------------------------------
  // ÉTAPE 3 : objectif
  // --------------------------------------------------

  double? _targetWeight;
  String? _motivation;

  double? get targetWeight => _targetWeight;
  String? get motivation => _motivation;

  // --------------------------------------------------
  // ÉTAPE 4 : défis du quotidien
  // --------------------------------------------------

  final List<LifeChallengeType> _selectedChallenges = [];

  String _otherChallenge = '';

  List<LifeChallengeType> get selectedChallenges =>
      List.unmodifiable(_selectedChallenges);

  String get otherChallenge => _otherChallenge;

  // ==================================================
  // ÉTAPE 1
  // ==================================================

  void setAddressingStyle(AddressingStyle style) {
    _addressingStyle = style;
    notifyListeners();
  }

  // ==================================================
  // ÉTAPE 2
  // ==================================================

  void setPersonalInformation({
    required int age,
    required double height,
    required double currentWeight,
    required String country,
  }) {
    _age = age;
    _height = height;
    _currentWeight = currentWeight;
    _country = country;

    notifyListeners();
  }

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }

  // ==================================================
  // ÉTAPE 3
  // ==================================================

  void setGoalInformation({
    required double targetWeight,
    required String motivation,
  }) {
    _targetWeight = targetWeight;
    _motivation = motivation;

    notifyListeners();
  }

  // ==================================================
  // ÉTAPE 4
  // ==================================================

  void toggleChallenge(LifeChallengeType challenge) {
    if (_selectedChallenges.contains(challenge)) {
      _selectedChallenges.remove(challenge);
    } else {
      _selectedChallenges.add(challenge);
    }

    notifyListeners();
  }

  bool hasChallenge(LifeChallengeType challenge) {
    return _selectedChallenges.contains(challenge);
  }

  void setOtherChallenge(String value) {
    _otherChallenge = value;
    notifyListeners();
  }

  // ==================================================
  // CRÉATION DU PROFIL
  // ==================================================

  Future<bool> createProfile({required int userId}) async {
    final challenges = _selectedChallenges
        .map(
          (type) => LifeChallenge(
            type: type,
            description: type == LifeChallengeType.other
                ? _otherChallenge
                : null,
          ),
        )
        .toList();

    _profile = CoachingProfile(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userId,
      addressingStyle: _addressingStyle ?? AddressingStyle.tu,
      age: _age ?? 0,
      height: _height ?? 0,
      currentWeight: _currentWeight ?? 0,
      country: _country ?? '',
      targetWeight: _targetWeight ?? 0,
      motivation: _motivation ?? '',
      challenges: challenges,
      otherChallenge: _otherChallenge,
    );

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.createProfile(_profile!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================================================
  // RESET
  // ==================================================

  void reset() {
    _profile = null;

    _addressingStyle = null;

    _age = null;
    _height = null;
    _currentWeight = null;
    _country = null;

    _targetWeight = null;
    _motivation = null;

    _selectedChallenges.clear();

    _otherChallenge = '';

    notifyListeners();
  }
}
