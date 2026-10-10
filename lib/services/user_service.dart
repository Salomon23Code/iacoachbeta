import '../models/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  Future<User> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String country,
  }) async {
    final response = await _apiService.post(
      '/users',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'country': country,
      },
    );
    final data = response['data'];
    return User.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<User> getUser(int userId) async {
    final response = await _apiService.get('/users/$userId');

    final data = response['data'];
    return User.fromJson(data is Map<String, dynamic> ? data : response);
  }

  Future<User> updateUser({
    required int userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    int? age,
    double? height,
    double? currentWeight,
  }) async {
    final body = <String, dynamic>{};

    if (firstName != null) {
      body['firstName'] = firstName;
    }

    if (lastName != null) {
      body['lastName'] = lastName;
    }

    if (email != null) {
      body['email'] = email;
    }

    if (phone != null) {
      body['phone'] = phone;
    }

    if (country != null) {
      body['country'] = country;
    }

    if (age != null) {
      body['age'] = age;
    }

    if (height != null) {
      body['height'] = height;
    }

    if (currentWeight != null) {
      body['currentWeight'] = currentWeight;
    }

    final response = await _apiService.put('/users/$userId', body: body);

    final data = response['data'];
    return User.fromJson(data is Map<String, dynamic> ? data : response);
  }
}
