import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class ForgotHeader extends StatelessWidget {
  const ForgotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: primary.withValues(alpha: 0.15),
          child: const Icon(Icons.lock_person,
              size: 55, color: primary),
        ),
        const SizedBox(height: 20),
        const Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter your email address below. We'll send you\n"
              "a 6-digit verification code to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.teal),
        ),
      ],
    );
  }
}