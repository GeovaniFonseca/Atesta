// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/exames/screens/adicionar_exame_screen.dart';
import 'package:hello_world/features/exames/widgets/exame.dart';

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
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Mudança de cor
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
                  return const Text('Algo deu errado',
                      style: TextStyle(color: Colors.red));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Indicador de carregamento
                }

                final exames = snapshot.data?.docs.map((DocumentSnapshot doc) {
                      return Exame.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id);
                    }).toList() ??
                    [];

                return ListView.builder(
                  itemCount: exames.length, // Define a quantidade de itens
                  itemBuilder: (context, index) {
                    Exame exame = exames[index];
                    return Card(
                      // Uso de Card para cada item para melhor visualização
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(exame.date,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 38, 87, 151))),
                        subtitle: Text(exame.tipo),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ExameDetalhesScreen(exame: exames[index]),
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
        backgroundColor: const Color.fromARGB(255, 38, 87, 151), // Cor de fundo
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
