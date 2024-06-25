// views/vacina_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/vacina.dart';
import 'vacina_detalhes_screen.dart';
import 'adicionar_vacina_screen.dart';

class VacinaScreen extends StatelessWidget {
  const VacinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Vacinas',
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
                  .collection('Vacinas')
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

                final vacinas = snapshot.data?.docs.map((DocumentSnapshot doc) {
                      return Vacina.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id);
                    }).toList() ??
                    [];
                return ListView.builder(
                  itemCount: vacinas.length,
                  itemBuilder: (context, index) {
                    final vacina = vacinas[index];
                    return Card(
                      surfaceTintColor: Colors.white,
                      elevation: 6,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          vacina.dateAplicacao,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 38, 87, 151),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vacina ${vacina.tipo}'),
                            Text(vacina.dependentId ?? 'Sem dependente'),
                          ],
                        ),
                        leading: const Icon(
                          Icons.vaccines,
                          color: Color.fromARGB(255, 38, 87, 151),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VacinaDetalhesScreen(vacina: vacina),
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
                builder: (context) => const AdicionarVacinaScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
