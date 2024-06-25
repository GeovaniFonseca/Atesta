// lib/viewmodels/signup_viewmodel.dart
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada ao cadastro de usuários.
class SignupViewModel extends ChangeNotifier {
  // Instância do serviço de banco de dados para interagir com o backend.
  final DatabaseService _databaseService = DatabaseService();

  // Indica se uma operação de cadastro está em andamento.
  bool _isLoading = false;

  /// Getter para o estado de carregamento.
  bool get isLoading => _isLoading;

  /// Método para registrar um novo usuário.
  ///
  /// [email] Email do usuário.
  /// [password] Senha do usuário.
  /// [name] Nome do usuário.
  /// [phone] Telefone do usuário.
  /// [age] Idade do usuário.
  ///
  /// Retorna `true` se o cadastro for bem-sucedido, `false` caso contrário.
  Future<bool> register(
      String email, String password, String name, String phone, int age) async {
    _isLoading = true;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.

    try {
      // Tenta registrar o usuário usando o serviço de banco de dados.
      await _databaseService.register(email, password, name, phone, age);
      return true;
    } catch (e) {
      // Retorna false se ocorrer um erro durante o cadastro.
      return false;
    } finally {
      // Garante que o estado de carregamento seja atualizado para false após a tentativa de cadastro.
      _isLoading = false;
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.
    }
  }
}
