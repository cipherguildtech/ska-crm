import 'package:flutter/material.dart';

const Color primary = Color(0xFF1BA39C);

class HrAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String role;
  final String department;

  const HrAppBar({
    super.key,
    required this.name,
    required this.role,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle = role;
    if (department.isNotEmpty && department != "Department") {
      subtitle = "$department $role";
    }

    String capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1);
    }

    return AppBar(
      toolbarHeight: 100,
      elevation: 0,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF1BA39C),
              Color(0xFF159C92),
              Color(0xFF0F7F73),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 28,
      ),

      title: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: primary, size: 30),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  capitalize(name),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}