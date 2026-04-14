import 'package:flutter/material.dart';
import 'text_field.dart';
import 'button.dart';

const Color primary = Colors.teal;

class LoginForm extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final bool isFormValid;

  const LoginForm({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onLogin,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: phoneController,
            label: "Phone Number",
            hint: "Enter your phone number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: passwordController,
            label: "Password",
            hint: "Enter password",
            icon: Icons.lock_outline,
            obscure: obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 18,
              ),
              onPressed: onTogglePassword,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 12,
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          LoginButton(
            isLoading: isLoading,
            onPressed: isFormValid ? onLogin : () {},
          ),
        ],
      ),
    );
  }
}