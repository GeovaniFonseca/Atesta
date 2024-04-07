// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/exames/widgets/exame.dart';

class AdicionarExameScreen extends StatefulWidget {
  const AdicionarExameScreen({super.key});

  @override
  _AdicionarExameScreenState createState() => _AdicionarExameScreenState();
}

class _AdicionarExameScreenState extends State<AdicionarExameScreen> {
  TextEditingController dataController = TextEditingController();
  String? tipoExameSelecionado;

  @override
  Widget build(BuildContext context) {
    // A UI permanece a mesma
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir as informações do exame médico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: dataController,
              decoration: const InputDecoration(
                labelText: 'Data',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? data = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (data != null) {
                  // Formatando a data para uma string no formato dd/MM/yyyy
                  dataController.text =
                      "${data.day}/${data.month}/${data.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoExameSelecionado,
              hint: const Text('Selecione o tipo de exame'),
              onChanged: (String? newValue) {
                setState(() {
                  tipoExameSelecionado = newValue;
                });
              },
              items: <String>[
                'Exame de Sangue',
                'Urina',
                'Colesterol',
                'Glicemia'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) => value == null ? 'Campo obrigatório' : null,
            ),
            ElevatedButton(
              child: const Text('Adicionar Exame'),
              onPressed: () async {
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null &&
                    dataController.text.isNotEmpty &&
                    tipoExameSelecionado != null) {
                  // Se userId não for nulo e os campos estiverem preenchidos, proceda para criar o exame
                  final Exame novoExame = Exame(
                      id:
                          "", // Geralmente o ID é gerado automaticamente pelo Firestore, então isso pode ser deixado em branco ou removido
                      data: dataController.text,
                      tipo:
                          tipoExameSelecionado!, // O '!' é usado para afirmar que o valor não é nulo
                      userId: userId // Já verificamos que isso não é nulo
                      );
                  // Adiciona o novo exame ao Firestore
                  await FirebaseFirestore.instance
                      .collection('exames')
                      .add(novoExame.toMap());

                  // Fecha a tela e retorna 'true' para indicar sucesso
                  Navigator.pop(context, true);
                } else {
                  // Caso contrário, mostre uma mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Todos os campos são obrigatórios e você deve estar logado.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
