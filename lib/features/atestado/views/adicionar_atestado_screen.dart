// lib/features/atestado/views/adicionar_atestado_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/atestado_model.dart';
import '../viewmodels/atestado_viewmodel.dart';
import '../../../services/storage_service.dart';

class AdicionarAtestadoScreen extends StatefulWidget {
  final AtestadoModel? atestadoParaEditar;
  const AdicionarAtestadoScreen({super.key, this.atestadoParaEditar});

  @override
  _AdicionarAtestadoScreenState createState() =>
      _AdicionarAtestadoScreenState();
}

class _AdicionarAtestadoScreenState extends State<AdicionarAtestadoScreen> {
  bool isLoading = false;
  final TextEditingController _nomeMedicoController = TextEditingController();
  final TextEditingController _dataEmissaoController = TextEditingController();
  final TextEditingController _quantidadeDiasController =
      TextEditingController();
  FocusNode dateFocusnode = FocusNode();
  FocusNode nomeMedicoFocusnode = FocusNode();
  FocusNode quantDiasFocusnode = FocusNode();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    nomeMedicoFocusnode.addListener(_handleFocusChange);
    if (widget.atestadoParaEditar != null) {
      // Preenche os campos com os dados do atestado para editar
      _nomeMedicoController.text = widget.atestadoParaEditar!.nomeMedico;
      _dataEmissaoController.text = widget.atestadoParaEditar!.dataEmissao;
      _quantidadeDiasController.text =
          widget.atestadoParaEditar!.quantidadeDias.toString();
    }
  }

  void _handleFocusChange() {
    if (nomeMedicoFocusnode.hasFocus ||
        dateFocusnode.hasFocus ||
        quantDiasFocusnode.hasFocus) {
      // Se algum campo tem foco, atualiza o estado para refletir a cor nova
      setState(() {});
    }
  }

  @override
  void dispose() {
    nomeMedicoFocusnode.removeListener(_handleFocusChange);
    super.dispose();
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.atestadoParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Atestado' : 'Adicionar Atestado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Insira as informações do atestado',
                style: TextStyle(
                    fontSize: 23,
                    color: Color.fromARGB(255, 38, 87, 151),
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: _nomeMedicoController,
              focusNode: nomeMedicoFocusnode,
              decoration: InputDecoration(
                label: Text(
                  'Nome do médico',
                  style: TextStyle(color: getIconColor(nomeMedicoFocusnode)),
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
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _dataEmissaoController,
              focusNode: dateFocusnode,
              decoration: InputDecoration(
                label: Text(
                  'Data de emissão',
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
                  _dataEmissaoController.text =
                      "${date.day}/${date.month}/${date.year}";
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(9)),
            TextField(
              controller: _quantidadeDiasController,
              focusNode: quantDiasFocusnode,
              decoration: InputDecoration(
                label: Text(
                  'Quantidade de Dias',
                  style: TextStyle(color: getIconColor(quantDiasFocusnode)),
                ),
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
              keyboardType: TextInputType.number,
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
                      _selectedFile = File(result.files.single.path!);
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
            SizedBox(
              width: 150,
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
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        String? userId = FirebaseAuth.instance.currentUser?.uid;
                        String errorMessage = '';

                        if (userId == null) {
                          isLoading = false;
                          errorMessage =
                              "Você precisa estar logado para adicionar um atestado.";
                        } else if (_nomeMedicoController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              "Por favor, preencha o nome do médico.";
                        } else if (_dataEmissaoController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              "Por favor, preencha a data de emissão do atestado";
                        } else if (_quantidadeDiasController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              "Por facor, preencha a quantidade de dias do atestado";
                        } else if (_selectedFile == null) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, selecione um arquivo para o atestado.';
                        }

                        if (errorMessage.isEmpty) {
                          String? uploadedFileUrl =
                              widget.atestadoParaEditar?.arquivoUrl;

                          if (_selectedFile != null) {
                            uploadedFileUrl = await StorageService()
                                .uploadFile(_selectedFile!);
                            if (uploadedFileUrl == null) {
                              errorMessage = 'Falha no upload do arquivo.';
                            }
                          }

                          final AtestadoModel novoAtestado = AtestadoModel(
                            id: widget.atestadoParaEditar?.id ??
                                '', // Usa o ID existente se estiver editando
                            nomeMedico: _nomeMedicoController.text,
                            dataEmissao: _dataEmissaoController.text,
                            quantidadeDias:
                                int.tryParse(_quantidadeDiasController.text) ??
                                    0,
                            arquivoUrl: uploadedFileUrl ?? '',
                            userId: userId!,
                          );

                          if (widget.atestadoParaEditar == null) {
                            // Adicionando um novo atestado
                            await Provider.of<AtestadoViewModel>(context,
                                    listen: false)
                                .addAtestado(novoAtestado);
                          } else {
                            // Atualizando um atestado existente
                            await Provider.of<AtestadoViewModel>(context,
                                    listen: false)
                                .updateAtestado(novoAtestado);
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Atestado adicionado com sucesso!'),
                            backgroundColor: Colors.green,
                          ));

                          Navigator.popUntil(context, (route) => route.isFirst);
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
                        "Adicionar Atestado",
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Color.fromARGB(255, 38, 87, 151),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
