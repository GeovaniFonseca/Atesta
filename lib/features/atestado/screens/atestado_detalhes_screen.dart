import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/atestado/screens/adicionar_atestado_screen.dart';
import 'package:hello_world/features/atestado/widgets/atestado.dart';

class AtestadoDetalheScreen extends StatelessWidget {
  final Atestado atestado;

  const AtestadoDetalheScreen({super.key, required this.atestado});

  Future<void> deleteAtestado(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('Atestados')
          .doc(atestado.id)
          .delete();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao deletar atestado')));
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
                  title: const Text('Nome do médico'),
                  subtitle: Text(atestado.nomeMedico),
                  // leading: const Icon(
                  //   Icons.calendar_today,
                  //   color: Color.fromARGB(255, 38, 87, 151),
                  // ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  title: const Text('Data emissão'),
                  subtitle: Text(atestado.dataEmissao),
                  // leading: const Icon(
                  //   Icons.description,
                  //   color: Color.fromARGB(255, 38, 87, 151),
                  // ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: ListTile(
                  title: const Text('Quantidade de dias'),
                  subtitle: Text(
                    atestado.quantidadeDias.toString(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 20),
              const Text('Preview do Arquivo:'),
              atestado.arquivoUrl!.isNotEmpty
                  ? Image.network(atestado.arquivoUrl!)
                  : const Text('Nenhum arquivo enviado.'),
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
