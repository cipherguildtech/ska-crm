import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_navigation.dart';
import '../forgot_password/forgot_password.dart';
import '../services/auth.dart';
import 'widgets/header.dart';
import 'widgets/form.dart';

const Color primary = Colors.teal;
const Color primaryLight = Color(0xFFB2DFDB);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 13),
        ),
        backgroundColor: isError ? Colors.red : primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  Future<void> _saveUserData(
      String name,
      String role,
      String phone,
      String department,
      ) async {
    try {
      final prefs = await SharedPreferences.getInstance();


      await prefs.setString('name', name);
      await prefs.setString('role', role);
      await prefs.setString('phone', phone);
      await prefs.setString('department', department);

    } catch (e) {
      throw Exception("Failed to save user data");
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.login(
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      final user = result['data']['user'];

      await _saveUserData(
        user['name']?.toString() ?? '',
        user['role']?.toString() ?? '',
        user['phone']?.toString() ?? '',
        user['department']?.toString() ?? '',
      );

      await Future.delayed(const Duration(milliseconds: 500));

      final prefs = await SharedPreferences.getInstance();
      final savedRole = prefs.getString('role');

      if (savedRole == null || savedRole.isEmpty) {
        _showMessage("Failed to save user session");
        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      _showMessage(result['message']);
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),

                    const LoginHeader(),

                    const SizedBox(height: 60),

                    LoginForm(
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      isLoading: _isLoading,
                      onLogin: _login,
                      isFormValid: _isFormValid,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onForgotPassword: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 110),

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
      ),
    );
  }
}