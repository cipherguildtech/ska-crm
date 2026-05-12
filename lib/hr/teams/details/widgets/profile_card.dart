import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? responseData;

  const ProfileCard({
    super.key,
    required this.user,
    required this.responseData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFF14B8A6).withValues(alpha: 0.12),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF14B8A6),
                  size: 34,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?["full_name"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${user?["department"] ?? "-"} ${user?["role"] ?? "-"}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _countCard(
                "Pending",
                "${responseData?["pending_tasks_count"] ?? 0}",
                const Color(0xFFFFA726),
              ),
              const SizedBox(width: 10),
              _countCard(
                "In Progress",
                "${responseData?["inprogress_tasks_count"] ?? 0}",
                const Color(0xFF42A5F5),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _countCard(
                "Review",
                "${responseData?["review_tasks_count"] ?? 0}",
                const Color(0xFFAB47BC),
              ),
              const SizedBox(width: 10),
              _countCard(
                "Cancelled",
                "${responseData?["cancelled_tasks_count"] ?? 0}",
                const Color(0xFFEF5350),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _countCard(
                "Incomplete",
                "${(responseData?["pending_tasks_count"] ?? 0) +
                    (responseData?["inprogress_tasks_count"] ?? 0)}",
                const Color(0xFFFF7043),
              ),
              const SizedBox(width: 10),
              _countCard(
                "Completed",
                "${responseData?["completed_tasks_count"] ?? 0}",
                const Color(0xFF66BB6A),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _countCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}