import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String role;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.role,
  });

  List<BottomNavigationBarItem> _getItems() {
    switch (role) {
      case 'ADMIN':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_outlined),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Manage",
          ),
        ];
      case 'DIRECTOR':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_outlined),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Manage",
          ),
        ];
      case 'HR':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_outlined),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: "Teams",
          ),
        ];
      case 'SALES':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_outlined),
            label: "Projects",
          ),
        ];
      case 'TEAM':
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: "My tasks",
          ),
        ];
      default:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      items: _getItems(),
    );
  }
}