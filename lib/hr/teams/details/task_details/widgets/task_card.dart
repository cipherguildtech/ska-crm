import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Map task;

  final String Function(dynamic) formatDate;

  const TaskCard({
    super.key,
    required this.task,
    required this.formatDate,
  });

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

  bool isEmptyValue(dynamic value) {
    if (value == null) return true;

    final text = value.toString().trim();

    return text.isEmpty ||
        text.toLowerCase() == "null" ||
        text == "-" ||
        text == "0";
  }

  String safeValue(dynamic value) {
    if (isEmptyValue(value)) return "-";

    return value.toString().trim();
  }

  String safeDate(dynamic value) {
    if (isEmptyValue(value)) return "-";

    try {
      final formatted = formatDate(value);

      if (
      formatted.isEmpty ||
          formatted.contains("1970") ||
          formatted.contains("00:00")
      ) {
        return "-";
      }

      return formatted;
    } catch (_) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {

    final status = safeValue(
      task["status"],
    );

    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    if (
                    !isEmptyValue(
                      task["title"],
                    )
                    )
                      Text(
                        safeValue(
                          task["title"],
                        ),

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                    if (
                    !isEmptyValue(
                      task["description"],
                    )
                    ) ...[

                      const SizedBox(height: 10),

                      Text(
                        safeValue(
                          task["description"],
                        ),

                        style: TextStyle(
                          color:
                          Colors.grey.shade700,
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (status != "-") ...[

                const SizedBox(width: 14),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor(status)
                        .withValues(alpha: .12),

                    borderRadius:
                    BorderRadius.circular(30),

                    border: Border.all(
                      color: statusColor(status)
                          .withValues(alpha: .22),
                    ),
                  ),

                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      Icon(
                        statusIcon(status),
                        size: 16,
                        color:
                        statusColor(status),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        status.replaceAll(
                          "_",
                          " ",
                        ),

                        style: TextStyle(
                          color:
                          statusColor(status),

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          /// CHIPS
          if (
          !isEmptyValue(
            safeDate(
              task["due_at"],
            ),
          )
          ) ...[

            const SizedBox(height: 22),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: [

                buildChip(
                  Icons.calendar_today_rounded,
                  "Deadline",
                  safeDate(
                    task["due_at"],
                  ),
                ),
              ],
            ),
          ],

          /// INFO SECTION
          const SizedBox(height: 28),

          if (
          !isEmptyValue(
            task["notes"],
          )
          )
            buildInfoTile(
              Icons.notes_rounded,
              "Notes",
              safeValue(
                task["notes"],
              ),
            ),

          if (
          !isEmptyValue(
            task["work_details"],
          )
          )
            buildInfoTile(
              Icons.work_outline_rounded,
              "Work Details",
              safeValue(
                task["work_details"],
              ),
            ),

          if (
          !isEmptyValue(
            task["notes_work"],
          )
          )
            buildInfoTile(
              Icons.sticky_note_2_rounded,
              "Work Notes",
              safeValue(
                task["notes_work"],
              ),
            ),

          if (
          !isEmptyValue(
            task["assigned_by"],
          )
          )
            buildInfoTile(
              Icons.person_rounded,
              "Assigned By",
              safeValue(
                task["assigned_by"],
              ),
            ),

          if (
          !isEmptyValue(
            safeDate(
              task["created_at"],
            ),
          )
          )
            buildInfoTile(
              Icons.calendar_month_rounded,
              "Created At",
              safeDate(
                task["created_at"],
              ),
            ),

          if (
          !isEmptyValue(
            safeDate(
              task["updated_at"],
            ),
          )
          )
            buildInfoTile(
              Icons.update_rounded,
              "Updated At",
              safeDate(
                task["updated_at"],
              ),
            ),

          if (
          !isEmptyValue(
            safeDate(
              task["completed_at"],
            ),
          )
          )
            buildInfoTile(
              Icons.check_circle_rounded,
              "Completed At",
              safeDate(
                task["completed_at"],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildChip(
      IconData icon,
      String title,
      String value,
      ) {

    if (isEmptyValue(value)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(30),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 16,
            color: Colors.teal,
          ),

          const SizedBox(width: 8),

          Text(
            "$title : $value",

            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoTile(
      IconData icon,
      String title,
      String value,
      ) {

    if (isEmptyValue(value)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.teal.withValues(
                alpha: .1,
              ),

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              size: 20,
              color: Colors.teal,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}