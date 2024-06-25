// viewmodels/vacina_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/database_service.dart';
import '../model/vacina.dart';

class VacinaViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Vacina> _vacinas = [];
  List<Vacina> get vacinas => _vacinas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<String> _dependents = ['Sem dependente'];
  List<String> get dependents => _dependents;

  Future<void> loadDependents() async {
    try {
      _dependents = ['Sem dependente'];
      _dependents.addAll(await _databaseService.loadDependents());
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao carregar dependentes';
      notifyListeners();
    }
  }

  Future<void> fetchVacinas() async {
    await _executeSafely(() async {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      // Log para verificar userId
      if (userId != null) {
        _vacinas = await _databaseService.getVacinasByUser(userId);
        // Log para verificar as vacinas carregadas
      }
    });
  }

  Future<void> deleteVacina(String id) async {
    await _executeSafely(() async {
      await _databaseService.deleteVacina(id);
      _vacinas.removeWhere((vacina) => vacina.id == id);
    });
  }

  Future<void> addVacina(Vacina vacina) async {
    await _executeSafely(() async {
      await _databaseService.addVacina(vacina);
      _vacinas.add(vacina);
    });
  }

  Future<void> updateVacina(Vacina vacina) async {
    await _executeSafely(() async {
      await _databaseService.updateVacina(vacina);
      final index = _vacinas.indexWhere((v) => v.id == vacina.id);
      if (index != -1) {
        _vacinas[index] = vacina;
      }
    });
  }

  Future<void> _executeSafely(Future<void> Function() operation) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await operation();
    } catch (e) {
      _errorMessage = 'Ocorreu um erro: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
