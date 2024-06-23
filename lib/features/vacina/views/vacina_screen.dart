// views/vacina_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/vacina_viewmodel.dart';
import 'vacina_detalhes_screen.dart';
import 'adicionar_vacina_screen.dart';

class VacinaScreen extends StatelessWidget {
  const VacinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Vacinas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Consumer<VacinaViewModel>(
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
            itemCount: viewModel.vacinas.length,
            itemBuilder: (context, index) {
              final vacina = viewModel.vacinas[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                surfaceTintColor: Colors.white,
                elevation: 6,
                child: ListTile(
                  title: Text(vacina.dateAplicacao,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 38, 87, 151))),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vacina ${vacina.tipo}'),
                      Text(vacina.dependentId ?? 'Sem dependente'),
                    ],
                  ),
                  leading: const Icon(
                    Icons.vaccines,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VacinaDetalhesScreen(vacina: vacina),
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
                builder: (context) => const AdicionarVacinaScreen()),
          );
          context.read<VacinaViewModel>().fetchVacinas();
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
