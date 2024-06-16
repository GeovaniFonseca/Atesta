import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/vacina.dart';
import 'adicionar_vacina_screen.dart';

class VacinaDetalhesScreen extends StatelessWidget {
  final Vacina vacina;

  const VacinaDetalhesScreen({super.key, required this.vacina});

  Future<void> deleteVacina(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Vacinas')
          .doc(vacina.id)
          .delete();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar vacina')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da vacina',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Mudança de cor
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Data de Aplicação'),
                  subtitle: Text(vacina.dateAplicacao),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (vacina.dateReforco != null)
                Card(
                  child: ListTile(
                    title: const Text('Data de Reforço'),
                    subtitle: Text(vacina.dateReforco!),
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 38, 87, 151),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Tipo da Vacina'),
                  subtitle: Text(vacina.tipo),
                  leading: const Icon(
                    Icons.vaccines,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (vacina.numeroLote != null)
                Card(
                  child: ListTile(
                    title: const Text('Número/Lote de Sequência'),
                    subtitle: Text(vacina.numeroLote!),
                    leading: const Icon(
                      Icons.confirmation_number,
                      color: Color.fromARGB(255, 38, 87, 151),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (vacina.efeitosColaterais != null)
                Card(
                  child: ListTile(
                    title: const Text('Efeitos Colaterais'),
                    subtitle: Text(vacina.efeitosColaterais!),
                    leading: const Icon(
                      Icons.warning,
                      color: Color.fromARGB(255, 38, 87, 151),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Dependente'),
                  subtitle: Text(vacina.dependentId ?? 'Não selecionado'),
                  leading: const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Preview do Arquivo:'),
                      vacina.arquivoUrl != null && vacina.arquivoUrl!.isNotEmpty
                          ? Image.network(vacina.arquivoUrl!)
                          : const Text('Nenhum arquivo enviado.'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              ActionChip(
                avatar: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 38, 87, 151),
                ),
                label: const Text('Deletar vacina'),
                onPressed: () => deleteVacina(context),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdicionarVacinaScreen(vacinaParaEditar: vacina),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 38, 87, 151),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
