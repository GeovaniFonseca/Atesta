// lib/viewmodels/signup_viewmodel.dart
import 'package:flutter/material.dart';

import '../../../services/database_service.dart';

class SignupViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> register(
      String email, String password, String name, String phone, int age) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.register(email, password, name, phone, age);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
