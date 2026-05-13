import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/change_password.dart';
import 'widgets/form.dart';
import 'widgets/header.dart';

const Color primary = Color(0xFF1BA39C);

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone') ?? "";
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : primary,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _submit() async {
    String pass = _passwordController.text.trim();
    String confirm = _confirmController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      _showMessage("All fields are required", isError: true);
      return;
    }

    if (pass.length < 6) {
      _showMessage("Password must be at least 6 characters", isError: true);
      return;
    }

    if (pass != confirm) {
      _showMessage("Passwords do not match", isError: true);
      return;
    }

    if (phone.isEmpty) {
      _showMessage("User not found. Please login again.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.resetPassword(
      phone: phone,
      password: pass,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    _showMessage(result['message'], isError: !result['success']);

    if (result['success']) {
      _showMessage("Password updated successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 0),

                  const ResetHeader(),

                  const SizedBox(height: 60),

                  ResetForm(
                    passwordController: _passwordController,
                    confirmController: _confirmController,
                    obscure1: _obscure1,
                    obscure2: _obscure2,
                    isLoading: _isLoading,
                    onSubmit: _submit,
                    onToggle1: () {
                      setState(() => _obscure1 = !_obscure1);
                    },
                    onToggle2: () {
                      setState(() => _obscure2 = !_obscure2);
                    },
                  ),

                  const SizedBox(height: 120),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright_rounded, size: 14, color: primary),
                      SizedBox(width: 5),
                      Text(
                        "Turing Tribes",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 1,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
