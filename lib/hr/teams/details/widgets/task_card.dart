import 'package:flutter/material.dart';
import '../task_details/task_details.dart';

class TaskCard extends StatelessWidget {
  final Map task;
  final String Function(dynamic) formatDate;

  const TaskCard({
    super.key,
    required this.task,
    required this.formatDate,
  });

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
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
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Icons.schedule_rounded;

      case "IN_PROGRESS":
        return Icons.autorenew_rounded;

      case "REVIEW":
        return Icons.rate_review_rounded;

      case "COMPLETED":
        return Icons.check_circle_rounded;

      case "CANCELLED":
        return Icons.cancel_rounded;

      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {

    final project = task["project"] ?? {};

    return InkWell(
      borderRadius: BorderRadius.circular(22),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetails(
              task: task,
              formatDate: formatDate,
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Text(
                    task["title"] ?? "-",

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor(
                      task["status"] ?? "",
                    ).withValues(alpha: .12),

                    borderRadius:
                    BorderRadius.circular(30),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(
                        statusIcon(
                          task["status"] ?? "",
                        ),
                        size: 15,
                        color: statusColor(
                          task["status"] ?? "",
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        task["status"] ?? "-",

                        style: TextStyle(
                          color: statusColor(
                            task["status"] ?? "",
                          ),

                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              task["description"] ??
                  project["description"] ??
                  "-",

              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 8),

                Text(
                  "Deadline : ${formatDate(task["due_at"])}",

                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}