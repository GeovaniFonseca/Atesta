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
  FocusNode dataFocusnode = FocusNode();
  FocusNode laudoFocusnode = FocusNode();
  FocusNode dateFocusnode = FocusNode();
  String? tipoExameSelecionado;
  String? fileUrl;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    laudoFocusnode.addListener(_handleFocusChange);
    if (widget.exameParaEditar != null) {
      dateController.text = widget.exameParaEditar!.date;
      tipoExameSelecionado = widget.exameParaEditar!.tipo;
      laudoController.text = widget.exameParaEditar!.laudo;
      // Aqui, você precisará ajustar para lidar com o arquivo do exame, se necessário
    }
  }

  void _handleFocusChange() {
    if (laudoFocusnode.hasFocus || dataFocusnode.hasFocus) {
      // Se algum campo tem foco, atualiza o estado para refletir a cor nova
      setState(() {});
    }
  }

  @override
  void dispose() {
    laudoFocusnode.removeListener(_handleFocusChange);
    super.dispose();
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
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
              focusNode: dateFocusnode,
              decoration: InputDecoration(
                label: Text(
                  'Data',
                  style: TextStyle(color: getIconColor(dateFocusnode)),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 38, 87, 151),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
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
              decoration: InputDecoration(
                fillColor: Colors.white, // Cor de fundo do campo
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 38, 87, 151),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextFormField(
              controller: laudoController,
              focusNode: laudoFocusnode,
              decoration: InputDecoration(
                label: Text(
                  'Laudo',
                  style: TextStyle(color: getIconColor(laudoFocusnode)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 38, 87, 151),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const Padding(padding: EdgeInsets.all(9)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(
                          255, 38, 87, 151)), // Cor de fundo do botão
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Raio do canto arredondado
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
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
                child: const Text(
                  'Selecionar Imagem/Documento',
                  style: TextStyle(
                    backgroundColor: Color.fromARGB(255, 38, 87, 151),
                    color: Color.fromARGB(255, 255, 255, 255), // Cor do texto
                    fontWeight: FontWeight.bold, // Negrito
                    fontSize: 16, // Tamanho do texto
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(
                    255, 38, 87, 151)), // Cor de fundo do botão
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Raio do canto arredondado
                  ),
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              ),
              child: const Text(
                'Adicionar Exane',
                style: TextStyle(color: Colors.white),
              ),
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
                } else if (selectedFile == null &&
                    widget.exameParaEditar?.arquivoUrl == null) {
                  errorMessage =
                      'Por favor, selecione um arquivo para o exame.';
                } else {
                  String? uploadedFileUrl = widget.exameParaEditar?.arquivoUrl;

                  if (selectedFile != null) {
                    uploadedFileUrl =
                        await StorageService().uploadFile(selectedFile!);
                    if (uploadedFileUrl == null) {
                      errorMessage = 'Falha no upload do arquivo.';
                    }
                  }

                  if (errorMessage.isEmpty) {
                    final Exame novoExame = Exame(
                      id: widget.exameParaEditar?.id ?? '',
                      date: dateController.text,
                      tipo: tipoExameSelecionado!,
                      laudo: laudoController.text,
                      arquivoUrl: uploadedFileUrl ?? '',
                      userId: userId,
                    );

                    if (widget.exameParaEditar == null) {
                      // Adicionando um novo exame
                      await FirebaseFirestore.instance
                          .collection('Exames')
                          .add(novoExame.toMap());
                    } else {
                      // Atualizando um exame existente
                      await FirebaseFirestore.instance
                          .collection('Exames')
                          .doc(widget.exameParaEditar!.id)
                          .update(novoExame.toMap());
                    }

                    Navigator.popUntil(context, (route) => route.isFirst);
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
