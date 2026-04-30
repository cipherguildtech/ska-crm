import 'package:flutter/material.dart';
import '../verify_otp/verify_otp.dart';
import '../services/auth.dart';
import 'widgets/form.dart';
import 'widgets/header.dart';

const Color primary = Color(0xFF1BA39C);

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text.trim();

    final isValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);

    if (isValid != _isEmailValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
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

  Future<void> _sendOtp() async {
    if (_emailController.text.trim().isEmpty) {
      _showMessage("Please enter email");
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.sendOtp(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      _showMessage(result['message']);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpPage(
            email: _emailController.text.trim(),
          ),
        ),
      );
    } else {
      _showMessage(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),

                  const ForgotHeader(),

                  const SizedBox(height: 60),

                  ForgotForm(
                    emailController: _emailController,
                    isLoading: _isLoading,
                    onSendOtp: _sendOtp,
                    isEmailValid: _isEmailValid,
                    onBackToLogin: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 150),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright_rounded,
                          size: 14, color: primary),
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