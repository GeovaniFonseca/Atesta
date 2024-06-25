// lib/features/consulta/views/consulta_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/consulta_model.dart';
import '../viewmodels/consulta_viewmodel.dart';
import 'adicionar_consulta_screen.dart';
import 'consulta_detalhes_screen.dart';

class ConsultaScreen extends StatelessWidget {
  const ConsultaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: userId == null
          ? const Center(
              child: Text('Não está logado!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Consultas')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Algo deu errado',
                          style: TextStyle(color: Colors.red)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final consultas =
                    snapshot.data?.docs.map((DocumentSnapshot doc) {
                          return ConsultaModel.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id);
                        }).toList() ??
                        [];
                return ListView.builder(
                  itemCount: consultas.length,
                  itemBuilder: (context, index) {
                    ConsultaModel consulta = consultas[index];
                    return Card(
                      surfaceTintColor: Colors.white,
                      elevation: 6,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Data: ${consulta.date}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 38, 87, 151),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Área Médica: ${consulta.areaMedica}'),
                            Text('Descrição: ${consulta.descricao}'),
                          ],
                        ),
                        leading: const Icon(
                          Icons.medical_services_outlined,
                          color: Color.fromARGB(255, 38, 87, 151),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConsultaDetalheScreen(consulta: consulta),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                    value: context.read<ConsultaViewModel>(),
                    child: const AdicionarConsultaScreen())),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        child: const Icon(Icons.add),
      ),
    );
  }
}
