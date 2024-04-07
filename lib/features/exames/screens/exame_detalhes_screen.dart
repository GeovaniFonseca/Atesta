import 'package:flutter/material.dart';
import 'package:hello_world/features/exames/widgets/exame.dart';

class ExameDetalhesScreen extends StatelessWidget {
  final Exame exame;

  const ExameDetalhesScreen({Key? key, required this.exame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Exame'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data: ${exame.date}'),
              Text('Tipo: ${exame.tipo}'),
              Text('Laudo: ${exame.laudo}'),
              SizedBox(height: 20),
              Text('Preview do Arquivo:'),
              exame.arquivoUrl!.isNotEmpty
                  ? Image.network(
                      exame.arquivoUrl!) // Exemplo simples com Image.network
                  : Text('Nenhum arquivo enviado.'),
            ],
          ),
        ),
      ),
    );
  }
}
