import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation.dart';
import 'package:ska_crm/utils/config.dart';
import 'forgot_password.dart';

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

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
  }


  // ✅ SNACKBAR
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primary,
        content: Text(message),
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

      print("👉 Saving user data...");

      await prefs.setString('name', name);
      await prefs.setString('role', role);
      await prefs.setString('phone', phone);
      await prefs.setString('department', department);

      if (_rememberMe) {
        await prefs.setBool('rememberMe', true);
        await prefs.setString('password', _passwordController.text);
      } else {
        await prefs.setBool('rememberMe', false);
        await prefs.remove('password');
      }

      // ✅ FORCE VERIFY SAVE
      print("✅ SAVED NAME: ${prefs.getString('name')}");
      print("✅ SAVED ROLE: ${prefs.getString('role')}");
      print("✅ SAVED PHONE: ${prefs.getString('phone')}");
      print("✅ SAVED DEPARTMENT: ${prefs.getString('department')}");

    } catch (e) {
      print("❌ SAVE ERROR: $e");
    }
  }

  // ✅ LOGIN API
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse("$baseUrl/auth/login");

      final body = {
        "phone": _phoneController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      print("🔵 RESPONSE: $data");

      setState(() => _isLoading = false);

      if (response.statusCode == 200 ||response.statusCode ==201 ){
        final user = data['user'];

        print("✅ LOGIN SUCCESS");
        print("USER: $user");

        // ✅ SAVE DATA
        await _saveUserData(
          user['name']?.toString() ?? '',
          user['role']?.toString() ?? '',
          user['phone']?.toString() ?? '',
          user['department']?.toString() ?? '',
        );

        // ✅ IMPORTANT: WAIT FOR STORAGE
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ VERIFY AGAIN
        final prefs = await SharedPreferences.getInstance();
        final savedRole = prefs.getString('role');

        print("🔴 FINAL CHECK ROLE: $savedRole");

        if (savedRole == null || savedRole.isEmpty) {
          _showMessage("Failed to save user session");
          return;
        }

        if (!mounted) return;

        print("🚀 NAVIGATING TO MAIN");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );

      } else {
        _showMessage(data['message'] ?? "Login failed");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("❌ LOGIN ERROR: $e");
      _showMessage("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // softer background
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔷 LOGO
                    Image.asset(
                      "assets/logo.png",
                      height: 70,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Login to continue to your dashboard",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    // ✅ CARD CONTAINER (ONLY FORM)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),

                        // 🔥 THIS IS THE IMPORTANT PART
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildFilledField(
                            controller: _phoneController,
                            label: "Phone Number",
                            hint: "Enter your phone number",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 15),

                          _buildFilledField(
                            controller: _passwordController,
                            label: "Password",
                            hint: "Enter password",
                            icon: Icons.lock_outline,
                            obscure: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1BA39C),
                                    Color(0xFF148F77)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _login,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                    color: Colors.white)
                                    : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔻 FOOTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.security, size: 14, color: primary),
                        SizedBox(width: 5),
                        Text(
                          "TURING TRIBES",
                          style: TextStyle(
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

  Widget _buildFilledField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType, // ✅ ADD THIS
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType, // ✅ APPLY HERE
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}