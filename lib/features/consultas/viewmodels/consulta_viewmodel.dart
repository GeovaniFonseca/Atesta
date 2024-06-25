// viewmodels/consulta_viewmodel.dart

import 'package:flutter/material.dart';
import '../model/consulta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultaViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<ConsultaModel> consultas = [];

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
}
