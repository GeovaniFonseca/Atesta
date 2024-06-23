// views/vacina_detalhes_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/vacina.dart';
import '../viewmodels/vacina_viewmodel.dart';
import 'adicionar_vacina_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class VacinaDetalhesScreen extends StatelessWidget {
  final Vacina vacina;

  const VacinaDetalhesScreen({super.key, required this.vacina});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vacinaViewModel = context.read<VacinaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da vacina',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                          ? GestureDetector(
                              onTap: () => _launchURL(vacina.arquivoUrl!),
                              child: Image.network(vacina.arquivoUrl!),
                            )
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
                onPressed: () {
                  vacinaViewModel.deleteVacina(vacina.id);
                  Navigator.pop(context);
                },
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
