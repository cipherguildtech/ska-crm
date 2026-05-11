import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/task_card.dart';
import 'widgets/project_card.dart';
import 'widgets/quotation_card.dart';
import 'widgets/task_history.dart';

class TaskDetails extends StatelessWidget {
  final Map task;

  final String Function(dynamic) formatDate;

  const TaskDetails({
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

  List parseList(dynamic data) {
    if (data == null) return [];

    if (data is List) return data;

    if (data is String) {
      try {
        final decoded = jsonDecode(data);

        if (decoded is List) {
          return decoded;
        }
      } catch (_) {}
    }

    return [];
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = task["project"] ?? {};

    final history = parseList(task["taskHistory"]);

    final quotations = parseList(task["quotations"]);

    final files = parseList(task["files"]);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          "Task Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Project Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              buildProjectCard(project,formatDate),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Task Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TaskCard(
                task: task,
                formatDate: formatDate,
              ),

              const SizedBox(height: 22),
              if (quotations.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Quotation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                ...quotations.map((quotation) {
                  return QuotationCard(
                    quotation: quotation,
                    formatDate: formatDate,
                  );
                }),

                const SizedBox(height: 22),
              ],
              /// FILES
              if (files.isNotEmpty) ...[
                sectionTitle("Files"),

                ...files.map((file) {
                  return fileCard(file.toString());
                }),

                const SizedBox(height: 22),
              ],
              if (history.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Text(
                      "Task History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                ...history.asMap().entries.map((entry) {

                  return TaskHistory(
                    history: history,
                    formatDate: formatDate,
                  );
                }),
              ],
            ],
          ),
        ),
    );
  }

  static Widget info(
      String title,
      dynamic value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 130,

            child: Text(
              "$title :",

              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value?.toString() ?? "-",

              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget fileCard(String url) {
    return InkWell(
      onTap: () {
        openUrl(url);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.grey.shade100,

          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [

            const Icon(Icons.attach_file_rounded),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Icon(Icons.open_in_new_rounded),
          ],
        ),
      ),
    );
  }

  Widget chip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        "$title : $value",

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
