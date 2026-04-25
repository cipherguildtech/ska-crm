import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class TeamsBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TeamsBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,

      type: BottomNavigationBarType.fixed,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cases_outlined),
          label: "My tasks",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
      ],
    );
  }
}
