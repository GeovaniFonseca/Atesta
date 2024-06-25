// lib/views/health_profile_edit_screen.dart
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/heath_profile_informations_viewmodel.dart';

/// Classe que define a tela de edição do perfil de saúde como um StatelessWidget.
class HealthProfileEditScreen extends StatelessWidget {
  // Dados do usuário passados para a tela.
  final Map<String, dynamic> userData;

  const HealthProfileEditScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cria uma instância de HealthProfileEditViewModel e inicializa com os dados do usuário.
      create: (context) => HealthProfileEditViewModel()..initialize(userData),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Perfil de Saúde'),
          actions: [
            // Botão para salvar as alterações do perfil de saúde.
            Consumer<HealthProfileEditViewModel>(
              builder: (context, viewModel, child) {
                return TextButton(
                  onPressed: () async {
                    if (await viewModel.saveProfile()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.amber),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<HealthProfileEditViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Qual o seu tipo sanguíneo?'),
                    Wrap(
                      spacing: 10.0,
                      children: [
                        'O-',
                        'O+',
                        'A-',
                        'A+',
                        'B-',
                        'B+',
                        'AB-',
                        'AB+'
                      ]
                          .map((type) => ChoiceChip(
                                label: Text(type),
                                selected:
                                    viewModel.healthProfile.bloodType == type,
                                onSelected: (selected) {
                                  viewModel.healthProfile.bloodType =
                                      selected ? type : null;

                                  viewModel.notifyListeners();
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Você é doador de sangue?'),
                    Wrap(
                      spacing: 10.0,
                      children: ['Sim', 'Não', 'Ainda não decidi']
                          .map((choice) => ChoiceChip(
                                label: Text(choice),
                                selected: viewModel.healthProfile.bloodDonor ==
                                    choice,
                                onSelected: (selected) {
                                  viewModel.healthProfile.bloodDonor =
                                      selected ? choice : null;

                                  viewModel.notifyListeners();
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Você é doador de órgãos?'),
                    Wrap(
                      spacing: 10.0,
                      children: ['Sim', 'Não', 'Ainda não decidi']
                          .map((choice) => ChoiceChip(
                                label: Text(choice),
                                selected: viewModel.healthProfile.organDonor ==
                                    choice,
                                onSelected: (selected) {
                                  viewModel.healthProfile.organDonor =
                                      selected ? choice : null;

                                  viewModel.notifyListeners();
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Atividade física'),
                    Wrap(
                      spacing: 10.0,
                      children: ['Intensa', 'Moderada', 'Sedentária']
                          .map((activity) => ChoiceChip(
                                label: Text(activity),
                                selected: viewModel.healthProfile.exercises ==
                                    activity,
                                onSelected: (selected) {
                                  viewModel.healthProfile.exercises =
                                      selected ? activity : null;
                                  viewModel.notifyListeners();
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Campo de texto para o peso.
                    TextField(
                      controller: viewModel.weightController,
                      decoration: InputDecoration(
                        labelText: 'Peso',
                        errorText: viewModel.weightError,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => viewModel.validateWeight(),
                    ),
                    const SizedBox(height: 20),
                    // Campo de texto para a altura.
                    TextField(
                      controller: viewModel.heightController,
                      decoration: InputDecoration(
                        labelText: 'Altura',
                        errorText: viewModel.heightError,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => viewModel.validateHeight(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
