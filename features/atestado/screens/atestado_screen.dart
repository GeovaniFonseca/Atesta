import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/atestado/screens/atestado_detalhes_screen.dart';
import 'package:hello_world/features/atestado/widgets/atestado.dart';

import 'adicionar_atestado_screen.dart';

class AtestadoScreen extends StatelessWidget {
  const AtestadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atestados',
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
                  .collection('Atestados')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo deu errado',
                      style: TextStyle(color: Colors.red));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final atestados =
                    snapshot.data?.docs.map((DocumentSnapshot doc) {
                          return Atestado.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id);
                        }).toList() ??
                        [];

                return ListView.builder(
                  itemCount: atestados.length,
                  itemBuilder: (context, index) {
                    Atestado atestado = atestados[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(atestado.nomeMedico),
                        subtitle: Text('Emitido em ${atestado.dataEmissao}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AtestadoDetalheScreen(atestado: atestado),
                              ));
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
                builder: (context) => const AdicionarAtestadoScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        child: const Icon(Icons.add),
      ),
    );
  }
}
