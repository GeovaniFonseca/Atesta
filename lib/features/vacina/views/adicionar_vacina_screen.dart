// views/adicionar_vacina_screen.dart

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../services/storage_service.dart';
import '../../navigation/bottom_navigation.dart';
import '../model/vacina.dart';
import '../viewmodels/vacina_viewmodel.dart';

class AdicionarVacinaScreen extends StatefulWidget {
  final Vacina? vacinaParaEditar;

  const AdicionarVacinaScreen({super.key, this.vacinaParaEditar});

  @override
  _AdicionarVacinaScreenState createState() => _AdicionarVacinaScreenState();
}

class _AdicionarVacinaScreenState extends State<AdicionarVacinaScreen> {
  final TextEditingController dateAplicacaoController = TextEditingController();
  final TextEditingController dateReforcoController = TextEditingController();
  final TextEditingController numeroLoteController = TextEditingController();
  final TextEditingController efeitosColateraisController =
      TextEditingController();
  final FocusNode dateAplicacaoFocusNode = FocusNode();
  final FocusNode dateReforcoFocusNode = FocusNode();
  final FocusNode numeroLoteFocusNode = FocusNode();
  final FocusNode efeitosColateraisFocusNode = FocusNode();

  String? tipoVacinaSelecionado;
  String? selectedDependent;
  File? selectedFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.vacinaParaEditar != null) {
      dateAplicacaoController.text = widget.vacinaParaEditar!.dateAplicacao;
      dateReforcoController.text = widget.vacinaParaEditar!.dateReforco ?? '';
      tipoVacinaSelecionado = widget.vacinaParaEditar!.tipo;
      numeroLoteController.text = widget.vacinaParaEditar!.numeroLote ?? '';
      efeitosColateraisController.text =
          widget.vacinaParaEditar!.efeitosColaterais ?? '';
      selectedDependent =
          widget.vacinaParaEditar!.dependentId ?? 'Sem dependente';
    }
    _loadDependents();

    dateAplicacaoFocusNode.addListener(_onFocusChange);
    dateReforcoFocusNode.addListener(_onFocusChange);
    numeroLoteFocusNode.addListener(_onFocusChange);
    efeitosColateraisFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    dateAplicacaoFocusNode.removeListener(_onFocusChange);
    dateReforcoFocusNode.removeListener(_onFocusChange);
    numeroLoteFocusNode.removeListener(_onFocusChange);
    efeitosColateraisFocusNode.removeListener(_onFocusChange);

    dateAplicacaoFocusNode.dispose();
    dateReforcoFocusNode.dispose();
    numeroLoteFocusNode.dispose();
    efeitosColateraisFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Future<void> _loadDependents() async {
    final vacinaViewModel = context.read<VacinaViewModel>();
    await vacinaViewModel.loadDependents();
    setState(() {});
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final vacinaViewModel = context.watch<VacinaViewModel>();
    final isEditMode = widget.vacinaParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Editar Vacina' : 'Adicionar Vacina',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Inserir as informações da vacina',
                style: TextStyle(
                  fontSize: 23,
                  color: Color.fromARGB(255, 38, 87, 151),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: dateAplicacaoController,
              focusNode: dateAplicacaoFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Data de Aplicação',
                  style: TextStyle(color: getIconColor(dateAplicacaoFocusNode)),
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
                  dateAplicacaoController.text =
                      "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateReforcoController,
              focusNode: dateReforcoFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Data de Reforço (opcional)',
                  style: TextStyle(color: getIconColor(dateReforcoFocusNode)),
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
                  dateReforcoController.text =
                      "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoVacinaSelecionado,
              hint: const Text('Selecione o tipo de vacina'),
              onChanged: (String? newValue) {
                setState(() {
                  tipoVacinaSelecionado = newValue;
                });
              },
              items: <String>['BCG', 'Hepatite B', 'Pentavalente', 'Rotavírus']
                  .map<DropdownMenuItem<String>>((String value) {
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
              items: vacinaViewModel.dependents
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
              controller: numeroLoteController,
              focusNode: numeroLoteFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Número/Lote de Sequência',
                  style: TextStyle(color: getIconColor(numeroLoteFocusNode)),
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
              keyboardType: TextInputType.text,
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextFormField(
              controller: efeitosColateraisController,
              focusNode: efeitosColateraisFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Efeitos Colaterais (opcional)',
                  style: TextStyle(
                      color: getIconColor(efeitosColateraisFocusNode)),
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
                              'Você precisa estar logado para adicionar uma vacina.';
                          isLoading = false;
                        } else if (dateAplicacaoController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, preencha a data de aplicação da vacina.';
                        } else if (tipoVacinaSelecionado == null) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, selecione o tipo de vacina.';
                        } else if (numeroLoteController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, preencha o número/lote da vacina';
                        } else {
                          String? uploadedFileUrl =
                              widget.vacinaParaEditar?.arquivoUrl;

                          if (selectedFile != null) {
                            uploadedFileUrl = await StorageService()
                                .uploadFile(selectedFile!);
                            if (uploadedFileUrl == null) {
                              errorMessage = 'Falha no upload do arquivo.';
                              isLoading = false;
                            }
                          }

                          if (errorMessage.isEmpty) {
                            final Vacina novaVacina = Vacina(
                              id: widget.vacinaParaEditar?.id ?? '',
                              dateAplicacao: dateAplicacaoController.text,
                              dateReforco: dateReforcoController.text.isNotEmpty
                                  ? dateReforcoController.text
                                  : null,
                              tipo: tipoVacinaSelecionado!,
                              userId: userId,
                              numeroLote: numeroLoteController.text.isNotEmpty
                                  ? numeroLoteController.text
                                  : null,
                              efeitosColaterais:
                                  efeitosColateraisController.text.isNotEmpty
                                      ? efeitosColateraisController.text
                                      : null,
                              arquivoUrl: uploadedFileUrl ?? '',
                              dependentId: selectedDependent == 'Sem dependente'
                                  ? null
                                  : selectedDependent,
                            );

                            if (widget.vacinaParaEditar == null) {
                              // Adicionando uma nova vacina
                              await FirebaseFirestore.instance
                                  .collection('Vacinas')
                                  .add(novaVacina.toMap());
                            } else {
                              // Atualizando uma vacina existente
                              await FirebaseFirestore.instance
                                  .collection('Vacinas')
                                  .doc(widget.vacinaParaEditar!.id)
                                  .update(novaVacina.toMap());
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Vacina adicionada com sucesso!'),
                              backgroundColor: Colors.green,
                            ));

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigation()));
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
                        "Adicionar Vacina",
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
}
