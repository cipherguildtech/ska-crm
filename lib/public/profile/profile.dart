import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile.dart';
import 'widgets/card.dart';
import 'widgets/header.dart';

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
  final ProfileService _profileService = ProfileService();
  bool isEditing = false;
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : primary,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String storedPhone = prefs.getString('phone') ?? "";

    if (storedPhone.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final user = await _profileService.fetchProfile(storedPhone);

    if (!mounted) return;

    if (user != null) {
      setState(() {
        name = user['full_name'] ?? "";
        email = user['email'] ?? "";
        phone = user['phone'] ?? "";
        role = user['role'] ?? "";
        department = user['department'] ?? "";

        _nameController.text = name;
        _emailController.text = email;

        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      _showMessage("Failed to load profile", isError: true);
    }
  }

  Future<void> _saveProfile() async {
    final result = await _profileService.updateProfile(
      phone: phone,
      name: _nameController.text,
      email: _emailController.text,
    );
    
    final statusCode = result['statusCode'];
    final data = result['data'];

    if (!mounted) return;

    if (statusCode == 200 || statusCode == 201) {
      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        isEditing = false;
      });

      _showMessage("Profile Updated Successfully");

    } else {
      _showMessage(
        data['message'] ?? "Update failed",
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() => isEditing = !isEditing);
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: primary),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              ProfileHeader(
                name: name,
                role: role,
                department: department,
              ),

              const SizedBox(height: 25),

              ProfileCard(
                isEditing: isEditing,
                name: name,
                email: email,
                phone: phone,
                nameController: _nameController,
                emailController: _emailController,
                onSave: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}