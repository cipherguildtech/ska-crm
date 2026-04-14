import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/dashboard.dart';
import 'widgets/drawer.dart';
import 'widgets/appbar.dart';
import 'widgets/navbar.dart';

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
      appBar: HrAppBar(
      name: name,
      role: role,
      department: department,
    ),

      drawer: HrDrawer(
        name: name,
        role: role,
        department: department,
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: HrBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}