import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback?
      onTap; // Adicionado a capacidade de passar uma função onTap

  const CardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.onTap, // Adicionado o parâmetro onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Utilizei InkWell para feedback visual no toque
      onTap: onTap,
      borderRadius: BorderRadius.circular(
          9.0), // Bordas arredondadas para o efeito do toque corresponder ao do card
      child: SizedBox(
        height: 120.0,
        child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          elevation: 6.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Icon(icon, color: iconColor),
                const SizedBox(
                    width:
                        16.0), // Ajustado para dar mais espaço entre o ícone e o texto
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centraliza verticalmente o conteúdo do card
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
