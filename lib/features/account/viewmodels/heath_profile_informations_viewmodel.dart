// lib/viewmodels/health_profile_edit_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../models/health_profile_model.dart';

class HealthProfileEditViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  HealthProfileModel healthProfile = HealthProfileModel();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String? weightError;
  String? heightError;

  void initialize(Map<String, dynamic> userData) {
    healthProfile = HealthProfileModel.fromMap(userData);
    weightController.text = healthProfile.weight ?? '';
    heightController.text = healthProfile.height ?? '';
  }

  bool validateWeight() {
    if (weightController.text.isEmpty) {
      weightError = 'Peso não pode estar vazio';
      notifyListeners();
      return false;
    }
    final weight = double.tryParse(weightController.text);
    if (weight == null || weight <= 0) {
      weightError = 'Peso deve ser um número positivo';
      notifyListeners();
      return false;
    }
    weightError = null;
    notifyListeners();
    return true;
  }

  bool validateHeight() {
    if (heightController.text.isEmpty) {
      heightError = 'Altura não pode estar vazia';
      notifyListeners();
      return false;
    }
    final height = double.tryParse(heightController.text);
    if (height == null || height <= 0) {
      heightError = 'Altura deve ser um número positivo';
      notifyListeners();
      return false;
    }
    heightError = null;
    notifyListeners();
    return true;
  }

  Future<bool> saveProfile() async {
    if (!validateWeight() || !validateHeight()) {
      return false;
    }
    healthProfile.weight = weightController.text;
    healthProfile.height = heightController.text;
    await _databaseService.updateUserHealthProfile(healthProfile.toMap());
    return true;
  }
}
