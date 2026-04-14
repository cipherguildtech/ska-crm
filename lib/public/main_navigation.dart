import 'dart:async';
import 'package:flutter/material.dart';
import '../sales/sales_navigation.dart';
import '../admin/admin_navigation.dart';
import '../teams/teams_navigation.dart';
import '../hr/hr_navigation.dart';
import 'login_page/login_page.dart';
import 'services/session.dart';

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
  final SessionService _sessionService = SessionService();

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
    final user = await _sessionService.getStoredUser();

    role = user['role'];
    department = user['department'];
    phone = user['phone'];

    if (role == null) {
      Future.delayed(const Duration(milliseconds: 300), _goToLogin);
      setState(() => isLoading = false);
      return;
    }

    _validateSession();

    _sessionTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _validateSession();
    });

    setState(() => isLoading = false);
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _navigateUser() {

    if (role == 'ADMIN' || role == 'DIRECTOR') {
      return const AdminMainPage();
    } else if (role == 'HR') {
      return const HrMainPage();
    } else if (role == 'SALES') {
      return const SalesMainPage();
    } else if (role == 'TEAM') {
      return const TeamsMainPage();
    } else {
      return const LoginPage();
    }
  }

  Future<void> _validateSession() async {
    if (_isDialogShown || phone == null) return;

    final result = await _sessionService.validateUser(phone!);

    if (!mounted) return;

    if (!result['success']) {
      _showMessage(result['message']);
      return;
    }

    if (!result['isActive']) {
      _showInactiveDialog(
        result['reason'].isNotEmpty
            ? result['reason']
            : "Account deactivated",
      );
    }
  }

  Future<void> _showInactiveDialog(String reason) async {
    await _sessionService.clearSession();

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
    return _navigateUser();
  }
}