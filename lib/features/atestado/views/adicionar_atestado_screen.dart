// lib/features/atestado/views/adicionar_atestado_screen.dart

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/storage_service.dart';
import '../../navigation/bottom_navigation.dart';
import '../model/atestado_model.dart';
import '../viewmodels/atestado_viewmodel.dart';

/// Tela para adicionar ou editar um atestado.
class AdicionarAtestadoScreen extends StatefulWidget {
  // Modelo de atestado para edição (opcional).
  final AtestadoModel? atestadoParaEditar;
  const AdicionarAtestadoScreen({super.key, this.atestadoParaEditar});

  @override
  _AdicionarAtestadoScreenState createState() =>
      _AdicionarAtestadoScreenState();
}

class _AdicionarAtestadoScreenState extends State<AdicionarAtestadoScreen> {
  bool isLoading = false;
  // Controladores de texto para os campos de entrada.
  final TextEditingController _nomeMedicoController = TextEditingController();
  final TextEditingController _dataEmissaoController = TextEditingController();
  final TextEditingController _quantidadeDiasController =
      TextEditingController();
  // Nós de foco para os campos de entrada.
  FocusNode nomeMedicoFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode quantDiasFocusNode = FocusNode();
  // Arquivo selecionado pelo usuário.
  File? _selectedFile;
  // Dependente selecionado.
  String? selectedDependent;

  @override
  void initState() {
    super.initState();
    // Preenche os controladores de texto com os dados do atestado para edição, se disponível.
    if (widget.atestadoParaEditar != null) {
      _nomeMedicoController.text = widget.atestadoParaEditar!.nomeMedico;
      _dataEmissaoController.text = widget.atestadoParaEditar!.dataEmissao;
      _quantidadeDiasController.text =
          widget.atestadoParaEditar!.quantidadeDias.toString();
      selectedDependent =
          widget.atestadoParaEditar!.dependentId ?? 'Sem dependente';
    }
    _loadDependents();

    // Adiciona listeners para os nós de foco.
    nomeMedicoFocusNode.addListener(_onFocusChange);
    dateFocusNode.addListener(_onFocusChange);
    quantDiasFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Remove os listeners dos nós de foco.
    nomeMedicoFocusNode.removeListener(_onFocusChange);
    dateFocusNode.removeListener(_onFocusChange);
    quantDiasFocusNode.removeListener(_onFocusChange);

    // Descarta os nós de foco.
    nomeMedicoFocusNode.dispose();
    dateFocusNode.dispose();
    quantDiasFocusNode.dispose();
    super.dispose();
  }

  /// Método chamado quando o foco muda em qualquer campo de entrada.
  void _onFocusChange() {
    setState(() {});
  }

  /// Carrega a lista de dependentes do usuário.
  Future<void> _loadDependents() async {
    final atestadoViewModel = context.read<AtestadoViewModel>();
    await atestadoViewModel.loadDependents();
    setState(() {});
  }

  /// Retorna a cor do ícone com base no foco do campo.
  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.atestadoParaEditar != null;
    final atestadoViewModel = context.watch<AtestadoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Editar Atestado' : 'Adicionar Atestado',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            // Título da tela.
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
            // Campo de entrada para o nome do médico.
            TextFormField(
              controller: _nomeMedicoController,
              focusNode: nomeMedicoFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Nome do médico',
                  style: TextStyle(color: getIconColor(nomeMedicoFocusNode)),
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
            // Campo de entrada para a data de emissão.
            TextField(
              controller: _dataEmissaoController,
              focusNode: dateFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Data de emissão',
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
                // Abre um seletor de data.
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
            // Campo de entrada para a quantidade de dias.
            TextField(
              controller: _quantidadeDiasController,
              focusNode: quantDiasFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Quantidade de Dias',
                  style: TextStyle(color: getIconColor(quantDiasFocusNode)),
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
            // Dropdown para selecionar o dependente (opcional).
            DropdownButtonFormField<String>(
              value: selectedDependent,
              hint: const Text('Selecione o dependente (opcional)'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDependent = newValue;
                });
              },
              items: atestadoViewModel.dependents
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
            const Padding(padding: EdgeInsets.all(9)),
            // Botão para selecionar um arquivo.
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
                  // Abre o seletor de arquivos.
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _selectedFile = File(result.files.single.path!);
                    });
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
            // Botão para adicionar ou editar o atestado.
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

                        // Verificações de validação para os campos obrigatórios.
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
                              "Por favor, preencha a quantidade de dias do atestado";
                        } else if (_selectedFile == null) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, selecione um arquivo para o atestado.';
                        }

                        if (errorMessage.isEmpty) {
                          String? uploadedFileUrl =
                              widget.atestadoParaEditar?.arquivoUrl;

                          // Realiza o upload do arquivo, se um novo arquivo foi selecionado.
                          if (_selectedFile != null) {
                            uploadedFileUrl = await StorageService()
                                .uploadFile(_selectedFile!);
                            if (uploadedFileUrl == null) {
                              errorMessage = 'Falha no upload do arquivo.';
                            }
                          }

                          final AtestadoModel novoAtestado = AtestadoModel(
                            id: widget.atestadoParaEditar?.id ?? '',
                            nomeMedico: _nomeMedicoController.text,
                            dataEmissao: _dataEmissaoController.text,
                            quantidadeDias:
                                int.tryParse(_quantidadeDiasController.text) ??
                                    0,
                            arquivoUrl: uploadedFileUrl ?? '',
                            userId: userId!,
                            dependentId: selectedDependent == 'Sem dependente'
                                ? null
                                : selectedDependent,
                          );

                          // Adiciona ou atualiza o atestado, dependendo do modo de edição.
                          if (widget.atestadoParaEditar == null) {
                            await Provider.of<AtestadoViewModel>(context,
                                    listen: false)
                                .addAtestado(novoAtestado);
                          } else {
                            await Provider.of<AtestadoViewModel>(context,
                                    listen: false)
                                .updateAtestado(novoAtestado);
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Atestado adicionado com sucesso!'),
                            backgroundColor: Colors.green,
                          ));

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BottomNavigation()));
                        }

                        // Exibe uma mensagem de erro, se necessário.
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
