// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/exames/widgets/exame.dart';

import '../../../services/storage_service.dart';

class AdicionarExameScreen extends StatefulWidget {
  final Exame? exameParaEditar;

  const AdicionarExameScreen({super.key, this.exameParaEditar});

  @override
  _AdicionarExameScreenState createState() => _AdicionarExameScreenState();
}

class _AdicionarExameScreenState extends State<AdicionarExameScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController laudoController = TextEditingController();
  String? tipoExameSelecionado;
  String? fileUrl;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    if (widget.exameParaEditar != null) {
      dateController.text = widget.exameParaEditar!.date;
      tipoExameSelecionado = widget.exameParaEditar!.tipo;
      laudoController.text = widget.exameParaEditar!.laudo;
      // Aqui, você precisará ajustar para lidar com o arquivo do exame, se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir as informações do exame médico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Data',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  dateController.text =
                      "${date.day}/${date.month}/${date.year}";
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
            TextFormField(
              controller: laudoController,
              decoration: InputDecoration(label: Text('Laudo')),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            ElevatedButton(
              child: Text('Selecionar Imagem/Documento'),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    selectedFile = File(result.files.single.path!);
                  });
                } else {
                  // Optionally handle the case when the user doesn't select a file
                }
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar Exame'),
              onPressed: () async {
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                String errorMessage = '';

                if (userId == null) {
                  errorMessage =
                      'Você precisa estar logado para adicionar um exame.';
                } else if (dateController.text.isEmpty) {
                  errorMessage = 'Por favor, preencha a data do exame.';
                } else if (tipoExameSelecionado == null) {
                  errorMessage = 'Por favor, selecione o tipo de exame.';
                } else if (selectedFile == null) {
                  errorMessage =
                      'Por favor, selecione um arquivo para o exame.';
                } else {
                  String? uploadedFileUrl =
                      await StorageService().uploadFile(selectedFile!);
                  if (uploadedFileUrl == null) {
                    errorMessage = 'Falha no upload do arquivo.';
                  } else {
                    final Exame novoExame = Exame(
                      id: "",
                      date: dateController.text,
                      tipo: tipoExameSelecionado!,
                      laudo: laudoController.text,
                      arquivoUrl: uploadedFileUrl,
                      userId: userId,
                    );

                    await FirebaseFirestore.instance
                        .collection('Exames')
                        .add(novoExame.toMap());

                    Navigator.pop(context, true);
                  }
                }

                if (errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
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
