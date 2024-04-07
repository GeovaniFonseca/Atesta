import 'package:flutter/material.dart';

import '../../atestado/screens/atestado_screen.dart';
import '../../consultas/screens/consulta_screen.dart';
import '../../exames/screens/exame_screen.dart';
import '../widgets/card_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 400,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConsultaScreen()),
                ),
                child: const CardItem(
                  icon: Icons.calendar_today,
                  title: 'Consultas',
                  subtitle: 'Veja os detalhes das suas consultas',
                  iconColor: Colors.red,
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExameScreen()),
                ),
                child: const CardItem(
                  icon: Icons.assignment,
                  title: 'Exames',
                  subtitle: 'Tenha os seus exames em qualquer lugar que for',
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AtestadoScreen()),
                ),
                child: const CardItem(
                  icon: Icons.description,
                  title: 'Atestados',
                  subtitle: 'Veja seu histórico de atestados',
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
