// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../account/views/profile_screen.dart';
import '../calendario/views/calendario_screen.dart';
import '../home/screens/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<BottomNavigation> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    const HomeScreen(),
    const ProfileScreen(),
    const CalendarioScreen(),
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
