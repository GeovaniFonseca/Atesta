// viewmodels/exame_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/database_service.dart';
import '../model/exame_model.dart';

class ExameViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  List<Exame> _exames = [];
  List<Exame> get exames => _exames;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<String> _dependents = ['Sem dependente'];
  List<String> get dependents => _dependents;

  String? _selectedDependent;
  String? get selectedDependent => _selectedDependent;

  Future<void> fetchExames() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        _exames = await _databaseService.fetchExames(userId);
      }
    } catch (e) {
      _errorMessage = 'Algo deu errado ao buscar exames';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  void updateSelectedDependent(String? dependent) {
    _selectedDependent = dependent;
    notifyListeners();
  }

  Future<void> deleteExame(String id) async {
    try {
      await _databaseService.deleteExame(id);
      _exames.removeWhere((exame) => exame.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao deletar exame';
      notifyListeners();
    }
  }
}
