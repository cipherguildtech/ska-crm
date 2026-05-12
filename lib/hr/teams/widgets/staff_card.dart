import 'package:flutter/material.dart';

class StaffCard extends StatelessWidget {

  final String name;
  final String role;
  final int tasks;
  final VoidCallback? onTap;

  const StaffCard({
    super.key,
    required this.name,
    required this.role,
    required this.tasks,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(bottom: 12),

      color: Colors.white,

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(15),

        side: BorderSide(
          color: Colors.teal.withValues(alpha: 0.1),
          width: 1,
        ),
      ),

      child: InkWell(

        borderRadius: BorderRadius.circular(15),

        onTap: onTap,

        child: ListTile(

          title: Text(
            name,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(role),

          trailing: Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              "$tasks Tasks",

              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}