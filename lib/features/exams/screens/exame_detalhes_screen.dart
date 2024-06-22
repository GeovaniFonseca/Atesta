import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/exame.dart';
import 'adicionar_exame_screen.dart';

class ExameDetalhesScreen extends StatelessWidget {
  final Exame exame;

  const ExameDetalhesScreen({super.key, required this.exame});

  Future<void> deleteExame(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Exames')
          .doc(exame.id)
          .delete();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao deletar exame')));
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do exame',
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
                  title: const Text('Data'),
                  subtitle: Text(exame.date),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  title: const Text('Tipo do exame'),
                  subtitle: Text(exame.tipo),
                  leading: const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  title: const Text('Laudo do exame'),
                  subtitle: Text(
                    exame.laudo,
                  ),
                  leading: const Icon(
                    Icons.document_scanner_outlined,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Dependente'),
                  subtitle: Text(exame.dependentId ?? 'Não selecionado'),
                  leading: const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                      exame.arquivoUrl!.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _launchURL(exame.arquivoUrl!),
                              child: Image.network(exame.arquivoUrl!),
                            )
                          : const Text('Nenhum arquivo enviado.'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 38, 87, 151)),
                label: const Text('Deletar exame'),
                onPressed: () => deleteExame(context),
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
                  AdicionarExameScreen(exameParaEditar: exame),
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
