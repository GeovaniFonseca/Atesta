// lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../models/user_model.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada ao login de usuários.
class LoginViewModel extends ChangeNotifier {
  // Instância do serviço de banco de dados para interagir com o backend.
  final DatabaseService _databaseService = DatabaseService();

  // Indica se uma operação de login está em andamento.
  bool _isLoading = false;
  // Modelo do usuário atualmente logado.
  UserModel? _user;

  /// Getter para o estado de carregamento.
  bool get isLoading => _isLoading;

  /// Getter para o modelo do usuário atualmente logado.
  UserModel? get user => _user;

  /// Método para realizar o login do usuário.
  ///
  /// [email] Email do usuário.
  /// [password] Senha do usuário.
  ///
  /// Retorna `true` se o login for bem-sucedido, `false` caso contrário.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.

    // Tenta realizar o login usando o serviço de banco de dados.
    bool success = await _databaseService.login(email, password);
    if (success) {
      // Se o login for bem-sucedido, carrega os dados do usuário.
      _user = await _databaseService.getUserData();
    }

    // Atualiza o estado de carregamento para false após a tentativa de login.
    _isLoading = false;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.
    return success;
  }
}
