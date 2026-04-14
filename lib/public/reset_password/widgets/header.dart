import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class ResetHeader extends StatelessWidget {
  const ResetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: primary.withValues(alpha: 0.15),
          child: const Icon(Icons.lock_reset_outlined, size: 55, color: primary),
        ),
        const SizedBox(height: 20),
        const Text(
          "Create New Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Your new password must be different from\npreviously used password",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.teal),
        ),
      ],
    );
  }
}