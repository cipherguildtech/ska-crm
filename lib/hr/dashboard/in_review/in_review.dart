import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/config.dart';
import '../in_progress/task_card.dart';
import '../in_progress/quotation_card.dart';
import '../in_progress/task_history.dart';

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
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  String formatDate(dynamic date) {
    if (date == null) return "-";

    final d = DateTime.tryParse(date.toString());
    if (d == null) return "-";

    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    return "${months[d.month - 1]} ${d.day}, ${d.year}";
  }

  Future<void> fetchTask() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tasks/task/details/${widget.taskId}"),
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

  void _showActionSheet() {
    _reasonController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HANDLE BAR
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Take Action",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 15),

              /// REASON INPUT
              TextField(
                controller: _reasonController,
                maxLines: 3,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                  hintText: "Enter reason...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [

                  /// REJECT
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_reasonController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reason required")),
                          );
                          return;
                        }

                        Navigator.pop(context);
                        _submitAction("reject");
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Reject"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// ACCEPT
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_reasonController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reason required")),
                          );
                          return;
                        }

                        Navigator.pop(context);
                        _submitAction("accept");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Accept",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        backgroundColor: isError ? Colors.red : Colors.teal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  Future<void> _submitAction(String action) async {
    final reason = _reasonController.text.trim();

    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('phone');

      if (phone == null) {
        _showMessage("User not logged in");
        return;
      }

      final payload = {
        "task_id": widget.taskId,
        "action": action,
        "phone": phone,
        "reason": reason,
      };

      final res = await http.post(
        Uri.parse("$baseUrl/tasks/accept_or_reject"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showMessage("Task $action successfully");
        Navigator.pop(context, true); // return success
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = data?['project'] ?? {};
    final task = data ?? {};
    final history = (data?['taskHistory'] ?? []) as List;
    final List quotation = List.from(data?['quotations'] ?? []);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Task"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.task_alt),
        label: const Text("Action"),
        onPressed: _showActionSheet,
      ),

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

            const Text(
              "Task Detail",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TaskCard(task:task,formatDate:formatDate),

            const SizedBox(height: 20),

            if (quotation.isNotEmpty) ...[
              const Text(
                "Quotation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: quotation.map((q) {
                  return QuotationCard(
                    quotation: q,
                    formatDate: formatDate,
                  );
                }).toList(),
              ),
            ] else ...[
              const SizedBox(height: 20),

            ],
            if (history.isNotEmpty) ...[
              const Text(
                "Task History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TaskHistory(
                history: history,
                formatDate: formatDate,
              ),
            ] else ...[

              const SizedBox(height: 20),

            ]
          ],
        ),
      ),
    );
  }
}