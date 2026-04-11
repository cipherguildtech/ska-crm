import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';

const Color primary = Color(0xFF1BA39C);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String phone = "";
  String role = "";
  String department = "";

  bool isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// 🔽 LOAD PROFILE FROM BACKEND
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString('phoneNumber') ?? "";

    try {
      final uri = Uri.parse("$baseUrl/user/profile");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneNumber,
        }),
      );

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final user = data['user'];

        setState(() {
          name = user['name'] ?? "";
          email = user['email'] ?? "";
          phone = user['phoneNumber'] ?? "";
          role = user['role'] ?? "";
          department = user['department'] ?? "";

          _nameController.text = name;
          _emailController.text = email;
        });
      }
    } catch (e) {
      debugPrint("Profile fetch error: $e");
    }
  }

  /// 🔽 UPDATE PROFILE (ONLY NAME + EMAIL)
  Future<void> _saveProfile() async {
    try {
      final uri = Uri.parse("$baseUrl/user/update-profile");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phone, // identify user
          "name": _nameController.text,
          "email": _emailController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() {
          name = _nameController.text;
          email = _emailController.text;
          isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Update failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// 🔽 VIEW FIELD
  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  /// 🔽 EDITABLE FIELD
  Widget _buildEditableField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() => isEditing = !isEditing);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔷 PROFILE HEADER
            CircleAvatar(
              radius: 45,
              backgroundColor: primary.withOpacity(0.2),
              child: const Icon(Icons.person, size: 50, color: primary),
            ),

            const SizedBox(height: 15),

            Text(
              name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(role, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 25),

            /// 🔷 CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [

                  /// NAME (Editable)
                  isEditing
                      ? _buildEditableField("Name", _nameController)
                      : _buildField("Name", name),

                  /// EMAIL (Editable)
                  isEditing
                      ? _buildEditableField("Email", _emailController)
                      : _buildField("Email", email),

                  /// PHONE (Read Only)
                  _buildField("Phone", phone),

                  /// ROLE (Read Only)
                  _buildField("Role", role),

                  /// DEPARTMENT (Read Only)
                  _buildField("Department", department),

                  if (isEditing)
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                        ),
                        onPressed: _saveProfile,
                        child: const Text("Save"),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}