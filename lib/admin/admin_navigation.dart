import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hr/dashboard/dashboard.dart';
import '../hr/projects/projects.dart';
import 'manage/service.dart';
import '../public/navigation/appbar.dart';
import '../public/navigation/drawer.dart';
import '../public/navigation/navbar.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 0;
  String name = "";
  String role = "";
  String department = "";

  final List<Widget> _pages = [
    const DashboardPage(),
    const Projects(),
    const ServicesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? "User";
      role = prefs.getString('role') ?? "Role";
      department = prefs.getString('department') ?? "";
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(name: name, role: role, department: department),

      drawer: CustomDrawer(name: name, role: role, department: department),

      body: _pages[_selectedIndex],

      bottomNavigationBar: CustomNavBar(
        role: "ADMIN",
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
