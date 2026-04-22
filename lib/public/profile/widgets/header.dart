import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String department;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    required this.department,
  });

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: primary.withValues(alpha: 0.2),
          child: const Icon(Icons.person, size: 50, color: primary),
        ),
        const SizedBox(height: 15),
        Text(
          capitalize(name),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (department.isNotEmpty)
          Text(department, style: const TextStyle(color: Colors.grey)),
        Text(role, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}