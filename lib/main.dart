// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/features/vacina/viewmodels/vacina_viewmodel.dart';
import 'package:hello_world/features/vacina/views/vacina_screen.dart';
import 'package:provider/provider.dart';

import 'features/account/viewmodels/login_viewmodel.dart';
import 'features/account/viewmodels/profile_viewmodel.dart';
import 'features/account/viewmodels/signup_viewmodel.dart';
import 'features/account/views/login_screen.dart';
import 'features/account/views/profile_screen.dart';
import 'features/atestado/viewmodels/atestado_viewmodel.dart';
import 'features/atestado/views/atestado_screen.dart';
import 'features/exame/viewmodels/exame_viewmodel.dart';
import 'features/exame/views/exame_screen.dart';
import 'firebase_options.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => AtestadoViewModel()),
        ChangeNotifierProvider(create: (_) => ExameViewModel()),
        ChangeNotifierProvider(create: (_) => VacinaViewModel()),
      ],
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/exameScreen': (context) => const ExameScreen(),
          '/atestadoScreen': (context) => const AtestadoScreen(),
          'vacinaScreen': (context) => const VacinaScreen(),
        },
      ),
    );
  }
}
