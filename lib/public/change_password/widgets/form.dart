import 'package:flutter/material.dart';
import 'fields.dart';
import 'button.dart';

const Color primary = Color(0xFF1BA39C);

class ResetForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscure1;
  final bool obscure2;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onToggle1;
  final VoidCallback onToggle2;

  const ResetForm({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.obscure1,
    required this.obscure2,
    required this.isLoading,
    required this.onSubmit,
    required this.onToggle1,
    required this.onToggle2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary),
      ),
      child: Column(
        children: [
          PasswordFields(
            passwordController: passwordController,
            confirmController: confirmController,
            obscure1: obscure1,
            obscure2: obscure2,
            onToggle1: onToggle1,
            onToggle2: onToggle2,
          ),
          const SizedBox(height: 25),
          ResetButton(
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}