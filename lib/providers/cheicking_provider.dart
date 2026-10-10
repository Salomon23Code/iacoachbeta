import 'package:flutter/foundation.dart';

import '../models/daily_checking.dart';
import '../services/api_service.dart';
import '../services/checkin_service.dart';

class CheckInProvider extends ChangeNotifier {
  final CheckInService _service;

  CheckInProvider({required ApiService apiService})
    : _service = CheckInService(apiService);

  List<dynamic> _checkIns = [];

  bool _isLoading = false;

  String? _error;

  List<dynamic> get checkIns => List.unmodifiable(_checkIns);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadCheckIns(int userId) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _checkIns = await _service.getCheckIns(userId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<bool> submitCheckIn({
    required int userId,
    required CheckInStatus status,
    String? reason,
  }) async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final checkIn = await _service.createCheckIn(
        userId: userId,
        status: status,
        reason: reason,
      );

      _checkIns.insert(0, checkIn);

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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
