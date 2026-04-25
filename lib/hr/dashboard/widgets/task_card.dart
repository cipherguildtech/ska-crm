import 'package:flutter/material.dart';
import '../assign_task/projectdetails.dart';
import '../in_progress/in_progress.dart';
import '../review/review.dart';

const Color primary = Color(0xFF1BA39C);

class TaskCard extends StatelessWidget {
  final Map task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isAssignTask = task.containsKey('project_code');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 200, // 👈 limit only, not force
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAssignTask
                      ? task['project_code'] ?? ""
                      : task['id'] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),

              if (!isAssignTask)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task['department'] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            isAssignTask
                ? task['description'] ?? ""
                : task['title'] ?? "",
            maxLines: 2, // allow 2 lines then ...
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.circle_outlined, size: 14, color: primary),
              const SizedBox(width: 5),

              Text(
                isAssignTask
                    ? (task['service_type'] ?? "To Assign")
                    : (task['status'] ?? "Unassigned"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: primary),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  if (isAssignTask) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectDetailsPage(
                          projectId: task['id'] ?? "",
                        ),
                      ),
                    );
                  } else {
                    final status = task['status'];

                    if (status == "IN_PROGRESS") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InProgressPage(taskId: task['id'] ?? ""),
                        ),
                      );
                    } else if (status == "REVIEW") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReviewTaskPage(taskId: task['id'] ?? ""),
                        ),
                      );
                    }
                  }
                },
                child: Text(isAssignTask ? "Assign" : "View"),
              )
            ],
          )
        ],
      ),
    );
  }
}