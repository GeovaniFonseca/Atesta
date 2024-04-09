// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../account/screens/profile_screen.dart';
import '../calendario/screens/calendario_screen.dart';
import '../home/screens/home_screen.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    const HomeScreen(),
    const ProfileScreen(),
    CalendarioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceAtual,
        children: _telas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendário'),
        ],
      ),
    );
  }
}
