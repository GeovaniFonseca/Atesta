// lib/viewmodels/profile_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada ao perfil de usuário.
class ProfileViewModel extends ChangeNotifier {
  // Instância do serviço de banco de dados para interagir com o backend.
  final DatabaseService _databaseService = DatabaseService();

  // URL da imagem de perfil do usuário.
  String? _profileImageUrl;
  // Dependente selecionado.
  String? _selectedDependent;
  // Lista de dependentes do usuário.
  List<String> _dependents = [];

  /// Getter para a URL da imagem de perfil do usuário.
  String? get profileImageUrl => _profileImageUrl;

  /// Getter para o dependente selecionado.
  String? get selectedDependent => _selectedDependent;

  /// Getter para a lista de dependentes do usuário.
  List<String> get dependents => _dependents;

  /// Carrega os dados do perfil do usuário a partir do serviço de banco de dados.
  Future<void> loadProfileData() async {
    var profileData = await _databaseService.loadProfileData();
    _profileImageUrl = profileData['profileImageUrl'];
    _dependents = List<String>.from(profileData['dependents']);
    _selectedDependent = profileData['selectedDependent'];
    notifyListeners(); // Notifica os ouvintes sobre a mudança nos dados do perfil.
  }

  /// Atualiza a imagem de perfil do usuário.
  ///
  /// [context] Contexto atual da aplicação.
  Future<void> updateProfilePicture(BuildContext context) async {
    var imageUrl = await _databaseService.updateProfilePicture(context);
    if (imageUrl != null) {
      _profileImageUrl = imageUrl;
      notifyListeners(); // Notifica os ouvintes sobre a mudança na imagem de perfil.
    }
  }

  /// Adiciona um novo dependente ao perfil do usuário.
  ///
  /// [dependentName] Nome do dependente a ser adicionado.
  Future<void> addDependent(String dependentName) async {
    await _databaseService.addDependent(dependentName);
    await loadProfileData(); // Recarrega os dados do perfil para refletir a adição do dependente.
  }

  /// Atualiza o dependente selecionado.
  ///
  /// [dependent] Nome do dependente selecionado.
  Future<void> updateSelectedDependent(String? dependent) async {
    await _databaseService.updateSelectedDependent(dependent);
    _selectedDependent = dependent;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no dependente selecionado.
  }

  /// Atualiza os dados do perfil do usuário.
  ///
  /// [name] Nome do usuário.
  /// [age] Idade do usuário.
  /// [phone] Telefone do usuário.
  /// [password] Senha do usuário.
  Future<void> updateProfile(
      {String? name, int? age, String? phone, String? password}) async {
    await _databaseService.updateProfile(
        name: name, age: age, phone: phone, password: password);
    await loadProfileData(); // Recarrega os dados do perfil para refletir as atualizações.
  }
}
