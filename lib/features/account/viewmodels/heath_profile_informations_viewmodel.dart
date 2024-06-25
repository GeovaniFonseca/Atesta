// lib/viewmodels/health_profile_edit_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../models/health_profile_model.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada à edição do perfil de saúde do usuário.
class HealthProfileEditViewModel extends ChangeNotifier {
  // Instância do serviço de banco de dados para interagir com o backend.
  final DatabaseService _databaseService = DatabaseService();

  // Modelo de perfil de saúde do usuário.
  HealthProfileModel healthProfile = HealthProfileModel();
  // Controladores de texto para os campos de peso e altura.
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  // Mensagens de erro para os campos de peso e altura.
  String? weightError;
  String? heightError;

  /// Inicializa o ViewModel com os dados do usuário.
  ///
  /// [userData] Dados do usuário.
  void initialize(Map<String, dynamic> userData) {
    healthProfile = HealthProfileModel.fromMap(userData);
    weightController.text = healthProfile.weight ?? '';
    heightController.text = healthProfile.height ?? '';
  }

  /// Valida o campo de peso.
  ///
  /// Retorna `true` se o campo for válido, `false` caso contrário.
  bool validateWeight() {
    if (weightController.text.isEmpty) {
      weightError = 'Peso não pode estar vazio';
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
      return false;
    }
    final weight = double.tryParse(weightController.text);
    if (weight == null || weight <= 0) {
      weightError = 'Peso deve ser um número positivo';
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
      return false;
    }
    weightError = null;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
    return true;
  }

  /// Valida o campo de altura.
  ///
  /// Retorna `true` se o campo for válido, `false` caso contrário.
  bool validateHeight() {
    if (heightController.text.isEmpty) {
      heightError = 'Altura não pode estar vazia';
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
      return false;
    }
    final height = double.tryParse(heightController.text);
    if (height == null || height <= 0) {
      heightError = 'Altura deve ser um número positivo';
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
      return false;
    }
    heightError = null;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de validação.
    return true;
  }

  /// Salva o perfil de saúde do usuário.
  ///
  /// Retorna `true` se o perfil for salvo com sucesso, `false` caso contrário.
  Future<bool> saveProfile() async {
    // Verifica se os campos de peso e altura são válidos.
    if (!validateWeight() || !validateHeight()) {
      return false;
    }
    // Atualiza o modelo de perfil de saúde com os valores dos campos.
    healthProfile.weight = weightController.text;
    healthProfile.height = heightController.text;
    // Atualiza o perfil de saúde do usuário no banco de dados.
    await _databaseService.updateUserHealthProfile(healthProfile.toMap());
    return true;
  }
}
