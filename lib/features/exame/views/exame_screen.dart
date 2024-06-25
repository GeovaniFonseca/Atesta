// views/exame_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/exame_model.dart';
import 'adicionar_exame_screen.dart';
import 'exame_detalhes_screen.dart';

class ExameScreen extends StatelessWidget {
  const ExameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Exames',
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
                  .collection('Exames')
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

                final exames = snapshot.data?.docs.map((DocumentSnapshot doc) {
                      return Exame.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id);
                    }).toList() ??
                    [];
                return ListView.builder(
                  itemCount: exames.length,
                  itemBuilder: (context, index) {
                    final exame = exames[index];
                    return Card(
                      surfaceTintColor: Colors.white,
                      elevation: 6,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          exame.date,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 38, 87, 151),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Exame de ${exame.tipo}'),
                            Text(
                                'Dependente: ${exame.dependentId ?? 'Sem dependente'}'),
                          ],
                        ),
                        leading: const Icon(
                          Icons.edit_document,
                          color: Color.fromARGB(255, 38, 87, 151),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExameDetalhesScreen(exame: exame),
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
                builder: (context) => const AdicionarExameScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
