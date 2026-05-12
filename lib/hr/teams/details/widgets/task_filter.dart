import 'package:flutter/material.dart';

class TaskFilterBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onChanged;

  const TaskFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  IconData _icon(String label) {
    switch (label) {
      case "PENDING":
        return Icons.schedule;
      case "IN_PROGRESS":
        return Icons.autorenew;
      case "REVIEW":
        return Icons.rate_review;
      case "COMPLETED":
        return Icons.check_circle;
      case "CANCELLED":
        return Icons.cancel;
      default:
        return Icons.all_inclusive;
    }
  }

  Color _color(String label) {
    switch (label) {
      case "PENDING":
        return Colors.orange;
      case "IN_PROGRESS":
        return Colors.blue;
      case "REVIEW":
        return Colors.purple;
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      "ALL",
      "PENDING",
      "IN_PROGRESS",
      "REVIEW",
      "COMPLETED",
      "CANCELLED",
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final label = filters[index];
          final isSelected = selectedFilter == label;
          final color = _color(label);

          return GestureDetector(
            onTap: () => onChanged(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withValues(alpha: 0.4)),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icon(label),
                    size: 16,
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label.replaceAll("_", " "),
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}