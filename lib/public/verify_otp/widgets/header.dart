import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class OtpHeader extends StatelessWidget {
  final String email;

  const OtpHeader({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: primary.withValues(alpha: 0.15),
          child: const Icon(Icons.verified_user,
              size: 55, color: primary),
        ),
        const SizedBox(height: 20),
        const Text(
          "Verify Your Mail",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 13, color: Colors.teal),
            children: [
              const TextSpan(
                text: "Please enter the 6 digit code sent to\n",
              ),
              TextSpan(
                text: email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}