import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service;

  UserProvider({required ApiService apiService})
    : _service = UserService(apiService);

  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _pendingFirstName;
  String? _pendingLastName;
  String? _pendingEmail;
  String? _pendingPassword;

  User? get currentUser => _currentUser;

  User? get user => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  bool get hasUser => _currentUser != null;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadUser(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _service.getUser(userId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void prepareAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    _pendingFirstName = firstName;
    _pendingLastName = lastName;
    _pendingEmail = email;
    _pendingPassword = password;
    _error = null;
    notifyListeners();
  }

  Future<bool> createAccount({
    required String phone,
    required String country,
  }) async {
    if (_isLoading) return false;

    final firstName = _pendingFirstName;
    final lastName = _pendingLastName;
    final email = _pendingEmail;
    final password = _pendingPassword;

    if (firstName == null ||
        lastName == null ||
        email == null ||
        password == null) {
      _error =
          'Les informations du compte sont manquantes. Recommencez l’inscription.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _service.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        country: country,
      );
      _pendingFirstName = null;
      _pendingLastName = null;
      _pendingEmail = null;
      _pendingPassword = null;
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

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> updateUser({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
  }) async {
    final currentUser = _currentUser;
    if (currentUser == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _service.updateUser(
        userId: currentUser.id,
        firstName: firstName ?? currentUser.firstName,
        lastName: lastName ?? currentUser.lastName,
        email: email ?? currentUser.email,
        phone: phone ?? currentUser.phone,
      );
      if (profileImage != null) {
        //_currentUser = _currentUser!.copyWith(profileImage: profileImage);
      }
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

  void logout() {
    _currentUser = null;
    _clearPendingAccount();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _clearPendingAccount();
    notifyListeners();
  }

  void _clearPendingAccount() {
    _pendingFirstName = null;
    _pendingLastName = null;
    _pendingEmail = null;
    _pendingPassword = null;
  }
}
