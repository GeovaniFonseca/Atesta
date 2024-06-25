// lib/features/consulta/views/consulta_detalhes_screen.dart

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/consulta_model.dart';
import 'adicionar_consulta_screen.dart';

class ConsultaDetalheScreen extends StatelessWidget {
  final ConsultaModel consulta;

  const ConsultaDetalheScreen({super.key, required this.consulta});

  Future<void> deleteConsulta(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Consultas')
          .doc(consulta.id)
          .delete();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar consulta')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da consulta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Data'),
                  subtitle: Text(consulta.date),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Área Médica'),
                  subtitle: Text(consulta.areaMedica),
                  leading: const Icon(
                    Icons.medical_services_outlined,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Descrição'),
                  subtitle: Text(consulta.descricao),
                  leading: const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ActionChip(
                avatar: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 255, 255, 255)),
                label: const Text('Deletar consulta'),
                onPressed: () => deleteConsulta(context),
                backgroundColor: const Color.fromARGB(255, 38, 87, 151),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdicionarConsultaScreen(consultaParaEditar: consulta),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
