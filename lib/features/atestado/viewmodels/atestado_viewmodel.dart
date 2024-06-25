// lib/viewmodels/atestado_viewmodel.dart

import 'package:flutter/material.dart';

import '../../../services/database_service.dart';
import '../model/atestado_model.dart';

class AtestadoViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<AtestadoModel> atestados = [];
  List<String> _dependents = ['Sem dependente'];
  List<String> get dependents => _dependents;

  Future<void> loadDependents() async {
    try {
      _dependents = ['Sem dependente'];
      _dependents.addAll(await _databaseService.loadDependents());
      notifyListeners();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> addAtestado(AtestadoModel atestado) async {
    await _databaseService.addAtestado(atestado);
    atestados.add(atestado);
    notifyListeners();
  }

  Future<void> updateAtestado(AtestadoModel atestado) async {
    await _databaseService.updateAtestado(atestado);
    final index = atestados.indexWhere((a) => a.id == atestado.id);
    if (index != -1) {
      atestados[index] = atestado;
      notifyListeners();
    }
  }

  Future<void> deleteAtestado(String atestadoId) async {
    await _databaseService.deleteAtestado(atestadoId);
    atestados.removeWhere((a) => a.id == atestadoId);
    notifyListeners();
  }
}
