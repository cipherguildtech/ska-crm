import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../public/navigation/navbar.dart';
import 'dashboard/dashboard.dart';
import '../public/navigation/drawer.dart';
import '../public/navigation/appbar.dart';
import 'projects/projects.dart';
import 'teams/teams.dart';

class HrMainPage extends StatefulWidget {
  const HrMainPage({super.key});

  @override
  State<HrMainPage> createState() => _HrMainPageState();
}

class _HrMainPageState extends State<HrMainPage> {
  int _selectedIndex = 0;
  String name = "";
  String role = "";
  String department = "";

  final List<Widget> _pages = [
    const DashboardPage(),
    const Projects(),
    const Teams(),
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
      role = prefs.getString('role') ?? "HR";
      department = prefs.getString('department') ?? "";
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      name: name,
      role: role,
      department: department,
    ),

      drawer: CustomDrawer(
        name: name,
        role: role,
        department: department,
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: CustomNavBar(
        role: "HR",
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}