// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/account/viewmodels/login_viewmodel.dart';
import 'features/account/viewmodels/profile_viewmodel.dart';
import 'features/account/viewmodels/signup_viewmodel.dart';
import 'features/account/views/login_screen.dart';
import 'features/account/views/profile_screen.dart';
import 'features/exams/screens/exame_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
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
        },
      ),
    );
  }
}
