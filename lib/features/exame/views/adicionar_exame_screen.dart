// views/adicionar_exame_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../services/storage_service.dart';
import '../model/exame_model.dart';
import '../viewmodels/exame_viewmodel.dart';

class AdicionarExameScreen extends StatefulWidget {
  final Exame? exameParaEditar;

  const AdicionarExameScreen({super.key, this.exameParaEditar});

  @override
  _AdicionarExameScreenState createState() => _AdicionarExameScreenState();
}

class _AdicionarExameScreenState extends State<AdicionarExameScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController laudoController = TextEditingController();
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode laudoFocusNode = FocusNode();

  String? tipoExameSelecionado;
  String? selectedDependent;
  File? selectedFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.exameParaEditar != null) {
      dateController.text = widget.exameParaEditar!.date;
      tipoExameSelecionado = widget.exameParaEditar!.tipo;
      laudoController.text = widget.exameParaEditar!.laudo;
      selectedDependent =
          widget.exameParaEditar!.dependentId ?? 'Sem dependente';
    }
    _loadDependents();
  }

  Future<void> _loadDependents() async {
    final exameViewModel = context.read<ExameViewModel>();
    await exameViewModel.loadDependents();
    setState(() {}); // Atualiza a tela depois de carregar os dependentes
  }

  @override
  Widget build(BuildContext context) {
    final exameViewModel = context.watch<ExameViewModel>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Inserir as informações do exame médico',
                style: TextStyle(
                    fontSize: 23,
                    color: Color.fromARGB(255, 38, 87, 151),
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: dateController,
              focusNode: dateFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Data',
                  style: TextStyle(color: getIconColor(dateFocusNode)),
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
                fillColor: Colors.white,
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
            DropdownButtonFormField<String>(
              value: selectedDependent,
              hint: const Text('Selecione o dependente (opcional)'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDependent = newValue;
                });
              },
              items: exameViewModel.dependents
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                fillColor: Colors.white,
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
              focusNode: laudoFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Laudo',
                  style: TextStyle(color: getIconColor(laudoFocusNode)),
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
                      const Color.fromARGB(255, 38, 87, 151)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                  );
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
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 38, 87, 151)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        String? userId = FirebaseAuth.instance.currentUser?.uid;
                        String errorMessage = '';

                        if (userId == null) {
                          errorMessage =
                              'Você precisa estar logado para adicionar um exame.';
                          isLoading = false;
                        } else if (dateController.text.isEmpty) {
                          isLoading = false;
                          errorMessage = 'Por favor, preencha a data do exame.';
                        } else if (tipoExameSelecionado == null) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, selecione o tipo de exame.';
                        } else if (selectedFile == null &&
                            widget.exameParaEditar?.arquivoUrl == null) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, selecione um arquivo para o exame.';
                        } else {
                          String? uploadedFileUrl =
                              widget.exameParaEditar?.arquivoUrl;

                          if (selectedFile != null) {
                            uploadedFileUrl = await StorageService()
                                .uploadFile(selectedFile!);
                            if (uploadedFileUrl == null) {
                              errorMessage = 'Falha no upload do arquivo.';
                              isLoading = false;
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
                              dependentId: selectedDependent == 'Sem dependente'
                                  ? null
                                  : selectedDependent,
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Exame adicionado com sucesso!'),
                              backgroundColor: Colors.green,
                            ));

                            Navigator.popUntil(
                                context, (route) => route.isFirst);
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

                        setState(() {
                          isLoading = false;
                        });
                      },
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        "Adicionar Exame",
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Color.fromARGB(255, 38, 87, 151),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }
}
