import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const UserInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color, // Usa a cor passada como argumento
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9), // Borda mais arredondada
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0), // Padding simétrico
        child: Row( 
          children: [
            Icon(icon, size: 30, color: const Color.fromARGB(179, 124, 124, 124)), // Ícone com cor mais suave
            const SizedBox(width: 5), // Espaço entre o ícone e o texto
            Expanded( // Para evitar overflow de texto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Para alinhamento vertical adequado
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromARGB(179, 0, 0, 0), // Texto com cor mais suave
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Ajuste no tamanho do texto
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 39, 39, 39), // Texto com cor mais suave
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
