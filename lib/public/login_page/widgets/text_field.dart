import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          cursorColor: Colors.teal,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            prefixIconColor: Colors.teal,
            suffixIcon: suffixIcon,
            suffixIconColor: Colors.teal,
            filled: true,
            fillColor: Colors.white,
            focusColor: Colors.teal,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12),
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