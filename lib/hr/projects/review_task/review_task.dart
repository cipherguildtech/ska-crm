import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/config.dart';
import '../../teams/details/task_details/widgets/task_card.dart';
import '../../teams/details/task_details/widgets/quotation_card.dart';
import '../../teams/details/task_details/widgets/task_history.dart';

class ReviewPage extends StatefulWidget {
  final Map task;

  const ReviewPage({super.key, required this.task});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String formatDate(dynamic date) {
    try {
      return DateTime.parse(date).toString().split(" ").first;
    } catch (_) {
      return "-";
    }
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

  // Future<void> submitAction(String status, String reason) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final phone = prefs.getString('phone');
  //
  //     if (phone == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("User not logged in")),
  //       );
  //       return;
  //     }
  //
  //     final payload = {
  //       "task_id": widget.taskId,
  //       "action": status,
  //       "phone": phone,
  //       "reason": reason,
  //     };
  //
  //     final res = await http.post(
  //       Uri.parse("$baseUrl/tasks/accept_or_reject"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(payload),
  //     );
  //
  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Task $status successfully")),
  //       );
  //
  //       Navigator.pop(context, true);
  //     } else {
  //       throw Exception(res.body);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );
  //   }
  // }
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
        "task_id": widget.task["id"],
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
    final task = widget.task;

    final List history = List.from(task['taskHistory'] ?? []);
    final List quotations = List.from(task['quotations'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      appBar: AppBar(
        title: const Text("Task Review"),
        backgroundColor: Colors.teal,
      ),

      /// ✅ FLOATING BUTTON FIXED HERE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.task_alt),
        label: const Text("Action"),
        onPressed: _showActionSheet,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TaskCard(
              task: task,
              formatDate: formatDate,
            ),

            const SizedBox(height: 20),

            sectionTitle("Task History"),

            if (history.isEmpty)
              const Text("No history available")
            else
              TaskHistory(
                history: history,
                formatDate: formatDate,
              ),

            const SizedBox(height: 20),

            sectionTitle("Quotation"),

            if (quotations.isEmpty)
              const Text("No quotation available")
            else
              Column(
                children: quotations.map((q) {
                  return QuotationCard(
                    quotation: q,
                    formatDate: formatDate,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}