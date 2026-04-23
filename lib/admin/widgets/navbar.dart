import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cases_outlined),
          label: "Projects",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Manage",
        ),
      ],
    );
  }
}