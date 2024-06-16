import 'package:flutter/material.dart';

class HealthInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const HealthInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
