import 'package:flutter/material.dart';
import 'filter_item.dart';

class FilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;
  final int toAssignCount;
  final int inProgressCount;
  final int reviewCount;

  const FilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.toAssignCount,
    required this.inProgressCount,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FilterItem(
            title: "To Assign ($toAssignCount)",
            isSelected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          FilterItem(
            title: "In Progress ($inProgressCount)",
            isSelected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
          FilterItem(
            title: "In Review ($reviewCount)",
            isSelected: selectedIndex == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}