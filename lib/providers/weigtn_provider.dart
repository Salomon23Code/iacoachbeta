import 'package:flutter/material.dart';

import '../models/weigth_record.dart';
import '../services/api_service.dart';
import '../services/weight_service.dart';

enum WeightPeriod { month, threeMonths, sixMonths, all }

class WeightProvider extends ChangeNotifier {
  final WeightService _service;

  WeightProvider({required ApiService apiService})
    : _service = WeightService(apiService);

  final List<WeightRecord> _records = [];
  bool _isLoading = false;
  String? _error;

  List<WeightRecord> get records => List.unmodifiable(_records);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadRecords(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final records = await _service.getRecords(userId);
      _records
        ..clear()
        ..addAll(records);
      _records.sort((left, right) => left.date.compareTo(right.date));
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  double? get currentWeight {
    if (_records.isEmpty) return null;

    return _records.last.weight;
  }

  double? get initialWeight {
    if (_records.isEmpty) return null;

    return _records.first.weight;
  }

  Future<bool> addWeight(double weight, {int? userId}) async {
    _error = null;
    try {
      final record = userId == null
          ? WeightRecord(
              id: DateTime.now().millisecondsSinceEpoch,
              userId: 0,
              date: DateTime.now(),
              weight: weight,
            )
          : await _service.createRecord(userId: userId, weight: weight);
      _records.add(record);
      _records.sort((left, right) => left.date.compareTo(right.date));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void initializeInitialWeight(double weight) {
    if (_records.isEmpty) {
      _records.add(
        WeightRecord(
          id: DateTime.now().millisecondsSinceEpoch,
          userId: 0,
          date: DateTime.now(),
          weight: weight,
        ),
      );

      notifyListeners();
    }
  }

  Future<bool> deleteRecord({
    required int userId,
    required int recordId,
  }) async {
    _error = null;
    try {
      await _service.deleteRecord(userId: userId, recordId: recordId);
      _records.removeWhere((record) => record.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  List<WeightRecord> getRecordsForPeriod(WeightPeriod period) {
    if (_records.isEmpty) {
      return [];
    }

    final now = DateTime.now();

    DateTime? startDate;

    switch (period) {
      case WeightPeriod.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;

      case WeightPeriod.threeMonths:
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;

      case WeightPeriod.sixMonths:
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;

      case WeightPeriod.all:
        startDate = null;
        break;
    }

    if (startDate == null) {
      return List.from(_records);
    }

    return _records.where((record) => record.date.isAfter(startDate!)).toList();
  }
}
