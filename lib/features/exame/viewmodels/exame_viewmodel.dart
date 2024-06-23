// viewmodels/exame_viewmodel.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/database_service.dart';
import '../model/exame_model.dart';

class ExameViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        final snapshot = await _firestore
            .collection('Exames')
            .where('userId', isEqualTo: userId)
            .get();
        _exames = snapshot.docs
            .map((doc) =>
                Exame.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      _errorMessage = 'Algo deu errado';
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
      await _firestore.collection('Exames').doc(id).delete();
      _exames.removeWhere((exame) => exame.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erro ao deletar exame';
      notifyListeners();
    }
  }
}
