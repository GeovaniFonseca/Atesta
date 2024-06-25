// lib/features/consulta/views/consulta_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/consulta_model.dart';
import '../viewmodels/consulta_viewmodel.dart';
import 'adicionar_consulta_screen.dart';
import 'consulta_detalhes_screen.dart';

/// Tela para exibir a lista de consultas do usuário.
class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  // Área médica selecionada pelo usuário.
  String? _selectedAreaMedica;

  // Lista de áreas médicas disponíveis para filtragem.
  final List<Map<String, dynamic>> _areasMedicas = [
    {'label': 'Ortopedia', 'icon': Icons.accessibility_new},
    {'label': 'Dermatologia', 'icon': Icons.color_lens},
    {'label': 'Neurologia', 'icon': Icons.memory},
    {'label': 'Oftalmologia', 'icon': Icons.visibility},
    {'label': 'Otorrino', 'icon': Icons.hearing},
    {'label': 'Dentista', 'icon': Icons.local_hospital},
    {'label': 'Cardiologia', 'icon': Icons.favorite},
  ];

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
      body: Column(
        children: [
          // Exibe a lista de áreas médicas para filtragem.
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _areasMedicas.length,
              itemBuilder: (context, index) {
                final area = _areasMedicas[index];
                final isSelected = _selectedAreaMedica == area['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAreaMedica = isSelected ? null : area['label'];
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 38, 87, 151)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(area['icon'],
                            color: isSelected
                                ? Colors.white
                                : const Color.fromARGB(255, 38, 87, 151)),
                        const SizedBox(height: 5),
                        Text(
                          area['label'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color.fromARGB(255, 38, 87, 151),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Exibe a lista de consultas filtradas ou todas as consultas.
          Expanded(
            child: userId == null
                // Exibe uma mensagem se o usuário não estiver logado.
                ? const Center(
                    child: Text('Não está logado!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)))
                // Constrói um StreamBuilder para obter a lista de consultas do Firestore.
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

                      // Converte os documentos do Firestore em objetos ConsultaModel e aplica o filtro de área médica.
                      final consultas = snapshot.data?.docs
                              .map((DocumentSnapshot doc) {
                                return ConsultaModel.fromMap(
                                    doc.data() as Map<String, dynamic>, doc.id);
                              })
                              .where((consulta) =>
                                  _selectedAreaMedica == null ||
                                  consulta.areaMedica == _selectedAreaMedica)
                              .toList() ??
                          [];
                      // Constrói a lista de cartões para exibir cada consulta.
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
                                  Text(
                                    'Descrição: ${consulta.descricao}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                    builder: (context) => ConsultaDetalheScreen(
                                        consulta: consulta),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      // Botão flutuante para adicionar uma nova consulta.
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
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
