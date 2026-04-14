import 'package:flutter/material.dart';

class PasswordFields extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscure1;
  final bool obscure2;
  final VoidCallback onToggle1;
  final VoidCallback onToggle2;

  const PasswordFields({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.obscure1,
    required this.obscure2,
    required this.onToggle1,
    required this.onToggle2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("New Password",
            style: TextStyle(fontSize: 12, color: Colors.black)),
        const SizedBox(height: 8),

        TextField(
          controller: passwordController,
          obscureText: obscure1,
          cursorColor: Colors.teal,
          decoration: InputDecoration(
            hintText: "Enter new password",
            focusColor: Colors.teal,
            prefixIcon: const Icon(Icons.lock_outline),
            prefixIconColor: Colors.teal,
            suffixIconColor: Colors.teal,
            suffixIcon: IconButton(
              icon: Icon(obscure1
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: onToggle1,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        const Text("Confirm Password",
            style: TextStyle(fontSize: 12, color: Colors.black)),
        const SizedBox(height: 8),

        TextField(
          controller: confirmController,
          obscureText: obscure2,
          cursorColor: Colors.teal,
          decoration: InputDecoration(
            hintText: "Confirm your password",
            focusColor: Colors.teal,
            prefixIcon: const Icon(Icons.lock_outline),
            prefixIconColor: Colors.teal,
            suffixIconColor: Colors.teal,
            suffixIcon: IconButton(
              icon: Icon(obscure2
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: onToggle2,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}