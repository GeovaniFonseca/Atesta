// lib/features/atestado/views/atestado_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/atestado_model.dart';
import '../viewmodels/atestado_viewmodel.dart';
import 'adicionar_atestado_screen.dart';
import 'atestado_detalhes_screen.dart';

/// Tela para exibir a lista de atestados do usuário.
class AtestadoScreen extends StatelessWidget {
  const AtestadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o ID do usuário autenticado.
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
          // Exibe uma mensagem se o usuário não estiver logado.
          ? const Center(
              child: Text('Não está logado!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
          // Constrói um StreamBuilder para obter a lista de atestados do Firestore.
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Atestados')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // Verifica se houve um erro na obtenção dos dados.
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Algo deu errado',
                          style: TextStyle(color: Colors.red)));
                }
                // Exibe um indicador de carregamento enquanto os dados estão sendo obtidos.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Converte os documentos do Firestore em uma lista de objetos AtestadoModel.
                final atestados =
                    snapshot.data?.docs.map((DocumentSnapshot doc) {
                          return AtestadoModel.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id);
                        }).toList() ??
                        [];

                // Constrói uma lista de cartões para exibir cada atestado.
                return ListView.builder(
                  itemCount: atestados.length,
                  itemBuilder: (context, index) {
                    AtestadoModel atestado = atestados[index];
                    return Card(
                      surfaceTintColor: Colors.white,
                      elevation: 6,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Emitido em ${atestado.dataEmissao}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 38, 87, 151),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Qnt de dias: ${atestado.quantidadeDias}'),
                            Text('Médico: ${atestado.nomeMedico}'),
                            Text(
                                'Dependente: ${atestado.dependentId ?? 'Sem dependente'}'),
                          ],
                        ),
                        leading: const Icon(
                          Icons.medical_services_outlined,
                          color: Color.fromARGB(255, 38, 87, 151),
                        ),
                        // Navega para a tela de detalhes do atestado ao clicar.
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AtestadoDetalheScreen(atestado: atestado),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
      // Botão flutuante para adicionar um novo atestado.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de adicionar atestado, mantendo o ViewModel atual.
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                    value: context.read<AtestadoViewModel>(),
                    child: const AdicionarAtestadoScreen())),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        child: const Icon(Icons.add),
      ),
    );
  }
}
