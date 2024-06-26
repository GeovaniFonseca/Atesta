// viewmodels/consulta_viewmodel.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../model/consulta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<ConsultaModel> consultas = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<String> _dependents = ['Sem dependente'];
  List<String> get dependents => _dependents;

  Future<void> addConsulta(ConsultaModel consulta) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('Consultas')
          .add(consulta.toMap());
      consultas.add(consulta);
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConsulta(ConsultaModel consulta) async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('Consultas')
          .doc(consulta.id)
          .update(consulta.toMap());
      int index = consultas.indexWhere((c) => c.id == consulta.id);
      if (index != -1) {
        consultas[index] = consulta;
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
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
}
