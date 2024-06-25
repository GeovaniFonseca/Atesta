// lib/viewmodels/calendar_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../atestado/model/atestado_model.dart';
import '../../consultas/model/consulta_model.dart';
import '../../exame/model/exame_model.dart';
import '../../vacina/model/vacina.dart';

class CalendarioViewModel extends ChangeNotifier {
  Map<DateTime, List<dynamic>> events = {};

  Future<void> loadAllEvents() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final atestadosSnapshot = await FirebaseFirestore.instance
        .collection('Atestados')
        .where('userId', isEqualTo: userId)
        .get();
    final consultasSnapshot = await FirebaseFirestore.instance
        .collection('Consultas')
        .where('userId', isEqualTo: userId)
        .get();
    final examesSnapshot = await FirebaseFirestore.instance
        .collection('Exames')
        .where('userId', isEqualTo: userId)
        .get();
    final vacinasSnapshot = await FirebaseFirestore.instance
        .collection('Vacinas')
        .where('userId', isEqualTo: userId)
        .get();

    final atestados = atestadosSnapshot.docs.map((doc) {
      return AtestadoModel.fromMap(doc.data(), doc.id);
    }).toList();
    final consultas = consultasSnapshot.docs.map((doc) {
      return ConsultaModel.fromMap(doc.data(), doc.id);
    }).toList();
    final exames = examesSnapshot.docs.map((doc) {
      return Exame.fromMap(doc.data(), doc.id);
    }).toList();
    final vacinas = vacinasSnapshot.docs.map((doc) {
      return Vacina.fromMap(doc.data(), doc.id);
    }).toList();

    final allEvents = [...atestados, ...consultas, ...exames, ...vacinas];
    events = {};

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

    notifyListeners();
  }
}
