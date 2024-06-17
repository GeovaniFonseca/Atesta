import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello_world/features/account/screens/login_screen.dart';
import 'package:hello_world/features/account/widgets/code_generator.dart';
import 'package:hello_world/features/exames/screens/exame_screen.dart';
import 'features/account/screens/profile_screen.dart';
import 'firebase_options.dart'; // Certifique-se de que este arquivo existe e está configurado corretamente

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
