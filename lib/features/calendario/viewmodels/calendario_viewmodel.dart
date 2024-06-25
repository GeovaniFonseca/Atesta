// lib/viewmodels/calendar_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../atestado/model/atestado_model.dart';
import '../../consultas/model/consulta_model.dart';
import '../../exame/model/exame_model.dart';
import '../../vacina/model/vacina.dart';

/// ViewModel para gerenciar a lógica de negócios relacionada aos eventos do calendário.
class CalendarioViewModel extends ChangeNotifier {
  // Mapa para armazenar os eventos do calendário, agrupados por data.
  Map<DateTime, List<dynamic>> events = {};

  /// Carrega todos os eventos (atestados, consultas, exames, vacinas) do usuário.
  Future<void> loadAllEvents() async {
    // Obtém o ID do usuário autenticado.
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Obtém os documentos de atestados do Firestore para o usuário autenticado.
    final atestadosSnapshot = await FirebaseFirestore.instance
        .collection('Atestados')
        .where('userId', isEqualTo: userId)
        .get();
    // Obtém os documentos de consultas do Firestore para o usuário autenticado.
    final consultasSnapshot = await FirebaseFirestore.instance
        .collection('Consultas')
        .where('userId', isEqualTo: userId)
        .get();
    // Obtém os documentos de exames do Firestore para o usuário autenticado.
    final examesSnapshot = await FirebaseFirestore.instance
        .collection('Exames')
        .where('userId', isEqualTo: userId)
        .get();
    // Obtém os documentos de vacinas do Firestore para o usuário autenticado.
    final vacinasSnapshot = await FirebaseFirestore.instance
        .collection('Vacinas')
        .where('userId', isEqualTo: userId)
        .get();

    // Converte os documentos de atestados em objetos AtestadoModel.
    final atestados = atestadosSnapshot.docs.map((doc) {
      return AtestadoModel.fromMap(doc.data(), doc.id);
    }).toList();
    // Converte os documentos de consultas em objetos ConsultaModel.
    final consultas = consultasSnapshot.docs.map((doc) {
      return ConsultaModel.fromMap(doc.data(), doc.id);
    }).toList();
    // Converte os documentos de exames em objetos Exame.
    final exames = examesSnapshot.docs.map((doc) {
      return Exame.fromMap(doc.data(), doc.id);
    }).toList();
    // Converte os documentos de vacinas em objetos Vacina.
    final vacinas = vacinasSnapshot.docs.map((doc) {
      return Vacina.fromMap(doc.data(), doc.id);
    }).toList();

    // Combina todos os eventos em uma única lista.
    final allEvents = [...atestados, ...consultas, ...exames, ...vacinas];
    events = {};

    // Agrupa os eventos por data.
    for (var event in allEvents) {
      final dateString = event is AtestadoModel
          ? event.dataEmissao
          : event is ConsultaModel
              ? event.date
              : event is Exame
                  ? event.date
                  : (event as Vacina).dateAplicacao;
      final date = DateTime(
          int.parse(dateString.split('/')[2]),
          int.parse(dateString.split('/')[1]),
          int.parse(dateString.split('/')[0]));
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(event);
    }

    // Notifica os ouvintes sobre a mudança nos eventos.
    notifyListeners();
  }
}
