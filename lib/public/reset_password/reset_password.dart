import 'package:flutter/material.dart';
import '../login_page/login_page.dart';
import '../services/auth.dart';
import 'widgets/form.dart';
import 'widgets/header.dart';

const Color primary = Color(0xFF1BA39C);

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

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

    setState(() => _isLoading = true);

    final result = await _authService.resetPassword(
      email: widget.email,
      password: pass,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    _showMessage(result['message'], isError: !result['success']);

    if (result['success']) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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