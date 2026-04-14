import 'package:flutter/material.dart';

const Color primary = Colors.teal;

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/logo.png",
          height: 100,
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Login to continue to your dashboard",
          style: TextStyle(fontSize: 16, color: primary),
        ),
      ],
    );
  }
}