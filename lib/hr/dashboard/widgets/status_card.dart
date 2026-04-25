import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color,size: 25),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$count",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color)),
              SizedBox(height: 12),
              Text(title,
                  style: TextStyle(fontSize: 11, color: color)),
            ],
          )
        ],
      ),
    );
  }
}