import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const EmailField({
    super.key,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email Address",
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          cursorColor: Colors.teal,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: "Enter your email",
            prefixIcon: const Icon(Icons.email_outlined),
            prefixIconColor: Colors.teal,
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