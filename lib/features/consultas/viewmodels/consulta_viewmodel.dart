// viewmodels/consulta_viewmodel.dart

import 'package:flutter/material.dart';
import '../model/consulta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada às consultas.
class ConsultaViewModel extends ChangeNotifier {
  // Indica se uma operação de carregamento está em andamento.
  bool isLoading = false;
  // Lista de consultas do usuário.
  List<ConsultaModel> consultas = [];

  /// Adiciona uma nova consulta ao Firestore e à lista de consultas.
  ///
  /// [consulta] O modelo de consulta a ser adicionado.
  Future<void> addConsulta(ConsultaModel consulta) async {
    isLoading = true;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.

    try {
      // Adiciona a consulta ao Firestore.
      await FirebaseFirestore.instance
          .collection('Consultas')
          .add(consulta.toMap());
      // Adiciona a consulta à lista de consultas local.
      consultas.add(consulta);
    } catch (e) {
      // Trate o erro (pode adicionar logs ou exibir mensagens de erro)
    } finally {
      isLoading = false;
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.
    }
  }

  /// Atualiza uma consulta existente no Firestore e na lista de consultas.
  ///
  /// [consulta] O modelo de consulta a ser atualizado.
  Future<void> updateConsulta(ConsultaModel consulta) async {
    isLoading = true;
    notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.

    try {
      // Atualiza a consulta no Firestore.
      await FirebaseFirestore.instance
          .collection('Consultas')
          .doc(consulta.id)
          .update(consulta.toMap());
      // Encontra o índice da consulta na lista de consultas local e a atualiza.
      int index = consultas.indexWhere((c) => c.id == consulta.id);
      if (index != -1) {
        consultas[index] = consulta;
      }
    } catch (e) {
      // Trate o erro (pode adicionar logs ou exibir mensagens de erro)
    } finally {
      isLoading = false;
      notifyListeners(); // Notifica os ouvintes sobre a mudança no estado de carregamento.
    }
  }
}
