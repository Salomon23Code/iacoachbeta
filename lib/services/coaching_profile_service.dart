import '../models/coaching_profile.dart';
import 'api_service.dart';

class CoachingProfileService {
  final ApiService _apiService;

  CoachingProfileService(this._apiService);

  Future<CoachingProfile?> getProfile(int userId) async {
    final response = await _apiService.get('/onboarding/$userId');
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return CoachingProfile.fromJson(data);
    }
    if (response.containsKey('id') || response.containsKey('userId')) {
      return CoachingProfile.fromJson(response);
    }
    return null;
  }

  Future<CoachingProfile> createProfile(CoachingProfile profile) async {
    final response = await _apiService.post(
      '/onboarding/${profile.userId}',
      body: _requestBody(profile),
    );
    final data = response['data'];
    return CoachingProfile.fromJson(
      data is Map<String, dynamic> ? data : response,
    );
  }

  Future<CoachingProfile> saveProfile(CoachingProfile profile) async {
    final response = await _apiService.put(
      '/onboarding/${profile.userId}',
      body: _requestBody(profile),
    );
    final data = response['data'];
    return CoachingProfile.fromJson(
      data is Map<String, dynamic> ? data : response,
    );
  }

  Map<String, dynamic> _requestBody(CoachingProfile profile) => {
    'addressingStyle': profile.addressingStyle.name.toUpperCase(),
    'age': profile.age,
    'height': profile.height,
    'currentWeight': profile.currentWeight,
    'country': profile.country,
    'targetWeight': profile.targetWeight,
    'motivation': profile.motivation,
    'challenges': profile.challenges
        .map(
          (challenge) => {
            'type': challenge.apiType,
            if (challenge.description != null)
              'description': challenge.description,
          },
        )
        .toList(),
    'otherChallenge': profile.otherChallenge,
  };
}
