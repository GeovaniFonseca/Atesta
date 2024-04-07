import 'package:flutter/material.dart';
import 'package:hello_world/features/account/screens/login_screen.dart';

import 'features/account/screens/profile_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu primeiro App',
      // A rota inicial quando o aplicativo é iniciado.
      initialRoute: '/login',
      // O mapeamento das rotas nomeadas para os widgets de tela.
      routes: {
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(), // Substitua pelo seu ProfileScreen Widget.
        // Adicione mais rotas conforme necessário.
      },
    );
  }
}
