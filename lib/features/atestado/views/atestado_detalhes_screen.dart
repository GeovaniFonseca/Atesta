// lib/features/atestado/views/atestado_detalhes_screen.dart

// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/atestado_model.dart';
import 'adicionar_atestado_screen.dart';

/// Tela para exibir os detalhes de um atestado específico.
class AtestadoDetalheScreen extends StatelessWidget {
  // Modelo de atestado a ser exibido.
  final AtestadoModel atestado;

  const AtestadoDetalheScreen({super.key, required this.atestado});

  /// Método para deletar o atestado atual.
  ///
  /// [context] Contexto da aplicação.
  Future<void> deleteAtestado(BuildContext context) async {
    try {
      // Deleta o atestado do Firestore.
      await FirebaseFirestore.instance
          .collection('Atestados')
          .doc(atestado.id)
          .delete();
      // Navega de volta para a tela anterior.
      Navigator.pop(context);
    } catch (e) {
      // Exibe uma mensagem de erro se a exclusão falhar.
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar atestado')));
    }
  }

  /// Método para abrir uma URL no navegador.
  ///
  /// [url] URL a ser aberta.
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
          'Detalhes do atestado',
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
              // Exibe o nome do médico.
              Card(
                child: ListTile(
                  title: const Text('Nome do médico'),
                  subtitle: Text(atestado.nomeMedico),
                  leading: const Icon(
                    Icons.medical_services_outlined,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Exibe a data de emissão do atestado.
              Card(
                child: ListTile(
                  title: const Text('Data emissão'),
                  subtitle: Text(atestado.dataEmissao),
                  leading: const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Exibe a quantidade de dias do atestado.
              Card(
                child: ListTile(
                  title: const Text('Quantidade de dias'),
                  subtitle: Text(
                    atestado.quantidadeDias.toString(),
                  ),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              // Exibe o dependente do atestado.
              Card(
                child: ListTile(
                  title: const Text('Dependente'),
                  subtitle: Text(atestado.dependentId ?? 'Não selecionado'),
                  leading: const Icon(
                    Icons.description,
                    color: Color.fromARGB(255, 38, 87, 151),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      atestado.arquivoUrl!.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _launchURL(atestado.arquivoUrl!),
                              child: Image.network(atestado.arquivoUrl!),
                            )
                          : const Text('Nenhum arquivo enviado.'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botão para deletar o atestado.
              ActionChip(
                avatar: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 255, 255, 255)),
                label: const Text('Deletar atestado'),
                onPressed: () => deleteAtestado(context),
                backgroundColor: const Color.fromARGB(255, 38, 87, 151),
              )
            ],
          ),
        ),
      ),
      // Botão flutuante para editar o atestado.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdicionarAtestadoScreen(atestadoParaEditar: atestado),
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
