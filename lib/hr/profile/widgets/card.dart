import 'package:flutter/material.dart';
import 'field.dart';

const Color primary = Color(0xFF1BA39C);

class ProfileCard extends StatefulWidget {
  final bool isEditing;
  final String name;
  final String email;
  final String phone;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onSave;

  const ProfileCard({
    super.key,
    required this.isEditing,
    required this.name,
    required this.email,
    required this.phone,
    required this.nameController,
    required this.emailController,
    required this.onSave,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}
class _ProfileCardState extends State<ProfileCard> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary, width: 1.2),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            widget.isEditing
                ? EditableField(
              label: "Name",
              controller: widget.nameController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is required";
                }
                return null;
              },
            )
                : ProfileField(label: "Name", value: widget.name),

            widget.isEditing
                ? EditableField(
              label: "Email",
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return "Enter valid email";
                }
                return null;
              },
            )
                : ProfileField(label: "Email", value: widget.email),

            ProfileField(label: "Phone", value: widget.phone),

            if (widget.isEditing)
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave();
                    }
                  },
                  child: const Text("Save"),
                ),
              )
          ],
        ),
      ),
    );
  }
}