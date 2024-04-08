import 'package:flutter/material.dart';
import 'package:hello_world/features/account/screens/login_screen.dart';
import 'package:hello_world/features/exames/screens/exame_screen.dart';

import 'features/account/screens/profile_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'arroz',
      // A rota inicial quando o aplicativo é iniciado.
      initialRoute: '/login',
      // O mapeamento das rotas nomeadas para os widgets de tela.
      routes: {
        '/login': (context) => LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/exameScreen': (context) => const ExameScreen(),
      },
    );
  }
}
