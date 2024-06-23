// views/exame_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/exame_viewmodel.dart';
import 'exame_detalhes_screen.dart';
import 'adicionar_exame_screen.dart';

class ExameScreen extends StatelessWidget {
  const ExameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Exames',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Consumer<ExameViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(
              child: Text(viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          return ListView.builder(
            itemCount: viewModel.exames.length,
            itemBuilder: (context, index) {
              final exame = viewModel.exames[index];
              return Card(
                surfaceTintColor: Colors.white,
                elevation: 6,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    exame.date,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 38, 87, 151)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exame de ${exame.tipo}'),
                      Text('Dependente: ${exame.dependentId}'),
                    ],
                  ),
                  leading: const Icon(
                    Icons.edit_document,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExameDetalhesScreen(exame: exame),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdicionarExameScreen()),
          );
          context.read<ExameViewModel>().fetchExames();
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
