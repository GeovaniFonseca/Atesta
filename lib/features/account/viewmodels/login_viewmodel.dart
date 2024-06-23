// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    bool success = await _databaseService.login(email, password);
    if (success) {
      _user = await _databaseService.getUserData();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
