import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/config.dart';

const Color primary = Color(0xFF1BA39C);

class ReviewTaskPage extends StatefulWidget {
  final String taskId;

  const ReviewTaskPage({super.key, required this.taskId});

  @override
  State<ReviewTaskPage> createState() => _ReviewTaskPageState();
}

class _ReviewTaskPageState extends State<ReviewTaskPage> {
  Map? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    final d = DateTime.tryParse(date);
    if (d == null) return date;

    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    return "${months[d.month - 1]} ${d.day}, ${d.year}";
  }

  Future<void> fetchTask() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/single/${widget.taskId}"),
      );

      if (response.statusCode == 200  || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);

        setState(() {
          data = jsonData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _handleAction(String status) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${status == "accept" ? "Accept" : "Reject"} Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Are you sure you want to $status this task?"),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter reason...",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Reason is required")),
                );
                return;
              }

              Navigator.pop(context);
              submitAction(status, controller.text);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<void> submitAction(String status, String reason) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/tasks/review"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "task_id": widget.taskId,
          "status": status,
          "reason": reason,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task $status successfully")),
        );

        Navigator.pop(context, true);
      } else {
        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  Widget projectCard(Map project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP STRIP
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F4F3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  "ID: ${project['project_code'] ?? ""}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primary),
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary),
                  ),
                  child: Text(
                    project['service_type'] ?? "",
                    style: const TextStyle(fontSize: 11),
                  ),
                )
              ],
            ),
          ),

          /// BODY
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['description'] ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "Customer: ${project['customer_email'] ?? ""}",
                  style: const TextStyle(color: Colors.black54),
                ),

                const Divider(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SERVICE TYPE",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text(project['service_type'] ?? ""),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("DEADLINE",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text(
                          formatDate(project['deadline']),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget taskCard(Map task) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP
          Row(
            children: [
              Text(
                "PRJ-${task['id']}",
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                task['status'] ?? "",
                style: const TextStyle(
                    fontSize: 11, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// TITLE
          Text(
            task['department'] ?? "",
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION
          Text(
            task['title'] ?? "",
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 10),

          /// META ROW
          Row(
            children: [
              const Icon(Icons.flag, size: 14, color: Colors.red),
              const SizedBox(width: 5),
              const Text("High", style: TextStyle(fontSize: 12)),

              const SizedBox(width: 15),

              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 5),
              Text(formatDate(task['due_at']),
                  style: const TextStyle(fontSize: 12)),

              const Spacer(),

              const Icon(Icons.attach_file, size: 14),
              const SizedBox(width: 3),
              const Text("0"),
            ],
          ),

          const SizedBox(height: 12),

          /// USER ROW (dummy like UI)
          Row(
            children: [
              const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
              const SizedBox(width: 8),

              const Expanded(
                child: LinearProgressIndicator(
                  value: 0.6,
                  color: primary,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: primary,
        ),
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget cardWrapper(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 15),
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = data?['project'] ?? {};
    final task = data ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("In Progress"),
        backgroundColor: primary,
      ),
      backgroundColor: const Color(0xFFF5F7FA),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text("Failed to load data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            const Text(
              "Project Detail",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// PROJECT CARD
            projectCard(project),

            const SizedBox(height: 20),

            /// TASK HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Task Details",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("View All", style: TextStyle(color: primary)),
              ],
            ),

            const SizedBox(height: 10),

            /// TASK CARD
            taskCard(task),
          ],
        ),
      ),
      bottomNavigationBar: data == null
          ? null
          : Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleAction("reject"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Reject"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleAction("accept"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                ),
                child: const Text("Accept"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}