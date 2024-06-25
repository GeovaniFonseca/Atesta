// lib/viewmodels/atestado_viewmodel.dart

import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../model/atestado_model.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada aos atestados.
class AtestadoViewModel extends ChangeNotifier {
  // Instância do serviço de banco de dados para interagir com o backend.
  final DatabaseService _databaseService = DatabaseService();

  // Lista de atestados do usuário.
  List<AtestadoModel> atestados = [];
  // Lista de dependentes do usuário.
  List<String> _dependents = ['Sem dependente'];

  /// Getter para a lista de dependentes do usuário.
  List<String> get dependents => _dependents;

  /// Carrega a lista de dependentes do usuário a partir do serviço de banco de dados.
  Future<void> loadDependents() async {
    try {
      _dependents = ['Sem dependente'];
      _dependents.addAll(await _databaseService.loadDependents());
      notifyListeners(); // Notifica os ouvintes sobre a mudança na lista de dependentes.
    } catch (e) {
      // Ignora erros, mas poderia adicionar um log para depuração.
    }
  }

  /// Adiciona um novo atestado ao perfil do usuário.
  ///
  /// [atestado] O modelo de atestado a ser adicionado.
  Future<void> addAtestado(AtestadoModel atestado) async {
    await _databaseService.addAtestado(atestado);
    atestados.add(atestado);
    notifyListeners(); // Notifica os ouvintes sobre a mudança na lista de atestados.
  }

  /// Atualiza um atestado existente.
  ///
  /// [atestado] O modelo de atestado a ser atualizado.
  Future<void> updateAtestado(AtestadoModel atestado) async {
    await _databaseService.updateAtestado(atestado);
    final index = atestados.indexWhere((a) => a.id == atestado.id);
    if (index != -1) {
      atestados[index] = atestado;
      notifyListeners(); // Notifica os ouvintes sobre a mudança no atestado atualizado.
    }
  }

  /// Deleta um atestado existente.
  ///
  /// [atestadoId] O ID do atestado a ser deletado.
  Future<void> deleteAtestado(String atestadoId) async {
    await _databaseService.deleteAtestado(atestadoId);
    atestados.removeWhere((a) => a.id == atestadoId);
    notifyListeners(); // Notifica os ouvintes sobre a mudança na lista de atestados.
  }
}
