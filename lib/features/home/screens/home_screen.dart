import 'package:flutter/material.dart';
import 'package:hello_world/features/vacina/screens/vacina_screen.dart';

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
          height: 600,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "INFORMAÇÕES DE SAÚDE",
                  style: TextStyle(
                      color: Color.fromARGB(255, 38, 87, 151),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(height: 16.0),
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
                  MaterialPageRoute(
                      builder: (context) => const AtestadoScreen()),
                ),
                child: const CardItem(
                  icon: Icons.description,
                  title: 'Atestados',
                  subtitle: 'Veja seu histórico de atestados',
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VacinaScreen()),
                ),
                child: const CardItem(
                  imagePath: 'lib/assets/icons/syringe-solid.svg',
                  title: 'Vacinas',
                  subtitle: 'Consulte as suas vacinas',
                  iconColor: Colors.green,
                  imageHeight: 40,
                  imageWidth: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
