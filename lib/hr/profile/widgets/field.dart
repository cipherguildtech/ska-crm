import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value,style: TextStyle(fontSize: 16),),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const EditableField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 5),
        TextFormField(
          cursorColor: Colors.teal,
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),

          onChanged: (value) {
            if (label == "Name") {
              final capitalized = capitalize(value);
              if (value != capitalized) {
                controller.value = controller.value.copyWith(
                  text: capitalized,
                  selection: TextSelection.collapsed(
                    offset: capitalized.length,
                  ),
                );
              }
            }
          },

          validator: validator,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}