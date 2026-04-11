import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ska_crm/public/default_page.dart';
import 'package:ska_crm/sales/sales_navigation.dart';
import '../admin/admin_navigation.dart';
import '../teams/teams_navigation.dart';
import 'login_page.dart';
import 'package:ska_crm/utils/config.dart';
import 'package:ska_crm/hr/hr_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  String? role;
  String? department;
  String? phone;

  bool isLoading = true;
  Timer? _sessionTimer;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text(message),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    role = prefs.getString('role');
    department = prefs.getString('department');
    phone = prefs.getString('phone');

    print("ROLE FROM PREFS: $role");

    if (role == null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _goToLogin();
      });
      setState(() => isLoading = false);
      return;
    }

    _validateSession();

    _sessionTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _validateSession();
    });

    setState(() => isLoading = false); // ✅ IMPORTANT
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _navigateUser() {
    print("ROLE: $role");

    if (role == 'ADMIN' || role == 'DIRECTOR') {
      return const AdminMainPage();
    } else if (role == 'HR') {
      return const HrMainPage();
    } else if (role == 'SALES') {
      return const SalesMainPage();
    } else if (role == 'TEAM') {
      return const TeamsMainPage();
    } else {
      return const DefaultPage();
    }
  }

  Future<void> _validateSession() async {
    if (_isDialogShown || phone == null  ) return;

    try {

      final url = Uri.parse('$baseUrl/users/${Uri.encodeComponent(phone!)}');
      final response =
      await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("CALLING API WITH PHONE: $phone");
        print("URL: $url");
        print("STATUS: ${response.statusCode}");
        print("BODY: ${response.body}");
        final isUserActive = data['is_active'] ?? false;
        final reason = data['userBlockReason'] ?? '';

        if (!isUserActive) {
          _showInactiveDialog(
            reason.isNotEmpty ? reason : "Account deactivated",
          );
        }
      }
    }

    on SocketException {
      _showMessage("No Internet connection");
    }

    on TimeoutException {
      _showMessage("Server timeout");
    }

    catch (e) {
      _showMessage("Something went wrong");
    }
  }

  Future<void> _showInactiveDialog(String reason) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    _isDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Access Denied"),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return _navigateUser(); // ✅ direct rendering
  }
}