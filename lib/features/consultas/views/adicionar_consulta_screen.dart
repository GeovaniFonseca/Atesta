// lib/features/consulta/views/adicionar_consulta_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/consulta_model.dart';
import '../viewmodels/consulta_viewmodel.dart';
import '../../navigation/bottom_navigation.dart';

class AdicionarConsultaScreen extends StatefulWidget {
  final ConsultaModel? consultaParaEditar;

  const AdicionarConsultaScreen({super.key, this.consultaParaEditar});

  @override
  _AdicionarConsultaScreenState createState() =>
      _AdicionarConsultaScreenState();
}

class _AdicionarConsultaScreenState extends State<AdicionarConsultaScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode descricaoFocusNode = FocusNode();
  String? areaMedicaSelecionada;
  String? selectedDependent;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.consultaParaEditar != null) {
      dateController.text = widget.consultaParaEditar!.date;
      areaMedicaSelecionada = widget.consultaParaEditar!.areaMedica;
      descricaoController.text = widget.consultaParaEditar!.descricao;
      selectedDependent =
          widget.consultaParaEditar!.dependentId ?? 'Sem dependente';
    }
    _loadDependents();

    dateFocusNode.addListener(_onFocusChange);
    descricaoFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    dateFocusNode.removeListener(_onFocusChange);
    descricaoFocusNode.removeListener(_onFocusChange);

    dateFocusNode.dispose();
    descricaoFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Future<void> _loadDependents() async {
    final consultaViewModel = context.read<ConsultaViewModel>();
    await consultaViewModel.loadDependents();
    setState(() {});
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final consultaViewModel = context.watch<ConsultaViewModel>();
    final isEditMode = widget.consultaParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Editar Consulta' : 'Adicionar Consulta',
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
                'Inserir as informações da consulta',
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
              value: areaMedicaSelecionada,
              hint: const Text('Selecione a área médica'),
              onChanged: (String? newValue) {
                setState(() {
                  areaMedicaSelecionada = newValue;
                });
              },
              items: <String>[
                'Ortopedia',
                'Dermatologia',
                'Neurologia',
                'Oftalmologia',
                'Otorrino',
                'Dentista',
                'Cardiologia'
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
              items: consultaViewModel.dependents
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
            const SizedBox(height: 16),
            TextFormField(
              controller: descricaoController,
              focusNode: descricaoFocusNode,
              decoration: InputDecoration(
                label: Text(
                  'Descrição da Consulta (opcional)',
                  style: TextStyle(color: getIconColor(descricaoFocusNode)),
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
            const SizedBox(height: 16),
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
                              'Você precisa estar logado para adicionar uma consulta.';
                          isLoading = false;
                        } else if (dateController.text.isEmpty) {
                          isLoading = false;
                          errorMessage =
                              'Por favor, preencha a data da consulta.';
                        } else if (areaMedicaSelecionada == null) {
                          isLoading = false;
                          errorMessage = 'Por favor, selecione a área médica.';
                        }

                        if (errorMessage.isEmpty) {
                          final ConsultaModel novaConsulta = ConsultaModel(
                            id: widget.consultaParaEditar?.id ?? '',
                            date: dateController.text,
                            areaMedica: areaMedicaSelecionada!,
                            descricao: descricaoController.text,
                            userId: userId!,
                            dependentId: selectedDependent == 'Sem dependente'
                                ? null
                                : selectedDependent,
                          );

                          if (widget.consultaParaEditar == null) {
                            await consultaViewModel.addConsulta(novaConsulta);
                          } else {
                            await consultaViewModel
                                .updateConsulta(novaConsulta);
                          }

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Consulta adicionada com sucesso!'),
                            backgroundColor: Colors.green,
                          ));

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BottomNavigation()));
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
                        "Adicionar Consulta",
                        style: TextStyle(
                          color: Colors.white,
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
