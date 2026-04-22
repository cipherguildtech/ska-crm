import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/drawer.dart';
import 'widgets/appbar.dart';
import 'widgets/navbar.dart';

class TeamsMainPage extends StatefulWidget {
  const TeamsMainPage({super.key});

  @override
  State<TeamsMainPage> createState() => _TeamsMainPageState();
}

class _TeamsMainPageState extends State<TeamsMainPage> {
  int _selectedIndex = 0;
  String name = "";
  String role = "";
  String department = "";

  final List<Widget> _pages = [
    const Center(child: Text("Dashboard")),
    const Center(child: Text("Projects")),
    const Center(child: Text("Teams")),
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
      appBar: TeamsAppBar(
        name: name,
        role: role,
        department: department,
      ),

      drawer: TeamsDrawer(
        name: name,
        role: role,
        department: department,
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: TeamsBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}