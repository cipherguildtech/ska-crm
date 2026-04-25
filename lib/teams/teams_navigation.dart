import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ska_crm/teams/pages/dashboard/dashboard.dart';
import 'package:ska_crm/teams/pages/my_tasks/my_tasks.dart';
import 'package:ska_crm/teams/widgets/navbar.dart';

import '../public/navigation/appbar.dart';
import '../public/navigation/drawer.dart';

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
    Dashboard(),
    TasksPage(),
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
      appBar: CustomAppBar(name: name, role: role, department: department),

      drawer: CustomDrawer(name: name, role: role, department: department),

      body: _pages[_selectedIndex],

      bottomNavigationBar: TeamsBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
