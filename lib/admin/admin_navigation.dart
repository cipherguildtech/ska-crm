import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  String role = "";
  String department = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString('role') ?? "";
      department = prefs.getString('department') ?? "";
    });
  }

  String get title {
    if (role == 'ADMIN') return "Welcome to Admin Dashboard";
    if (role == 'HR') return "Welcome to HR Dashboard";
    if (role == 'SALES') return "Welcome to Sales Dashboard";
    return "Welcome to Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}