import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sales_service.dart';

class RequestCancellationPage extends StatefulWidget {
  final String code;
  const RequestCancellationPage({super.key, required this.code});

  @override
  State<RequestCancellationPage> createState() =>
      _RequestCancellationPageState();
}

class _RequestCancellationPageState extends State<RequestCancellationPage> {
  final SalesService salesService = SalesService();
  bool isLoading = true;
  Map<String, dynamic> project = {};
  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    project = await salesService.fetchProjectByCode(code: widget.code);

    setState(() {
      isLoading = false;
    });
  }

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool showError = false;

  void submit() {
    setState(() {
      showError = reasonController.text.trim().isEmpty;
    });

    if (!showError) {
      updateStatus(status: 'CANCELLED', id: project['project_code']);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Request submitted")));
    }
  }

  Widget infoTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal.withValues(alpha: 0.1),
            child: Icon(icon, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.work_outline, color: Colors.teal),
              const SizedBox(width: 8),
              const Text(
                "ACTIVE PROJECT",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // TextButton(
              //   onPressed: () {},
              //   child: Text(
              //     "Full Details",
              //     style: TextStyle(color: Colors.teal.shade700),
              //   ),
              // ),
            ],
          ),
          const Divider(height: 20),
          infoTile("PROJECT ID", project['project_code'], Icons.description),
          infoTile("CUSTOMER NAME", project['customer']['name'], Icons.person),
          infoTile(
            "SERVICE TYPE",
            project['service_type'],
            Icons.card_giftcard,
          ),
          infoTile("CURRENT STATUS", project['status'], Icons.check_circle),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    bool isError = false,
    int maxLines = 3,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isError ? Colors.red : Colors.teal),
        ),
        suffixIcon: isError
            ? const Icon(Icons.error_outline, color: Colors.red)
            : null,
      ),
    );
  }

  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final changedBy = prefs.getString('phone') ?? "0";

    final result = await SalesService.createProjectHistory(
      projectCode: project['project_code'],
      projectId: project['id'],
      taskTitle: project['title'],
      changedBy: changedBy,
      taskOldStatus: project['status'],
      taskNewStatus: status,
      detail: reasonController.text,
      note: notesController.text,
      taskId: project['tasks'][0]['id'],
    );
    final res = await salesService.updateProjectStatusById(
      id: id,
      status: status,
    );

    if (res.isNotEmpty && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Request Cancellation"),
            Spacer(),
            Icon(Icons.info_outline),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCard(),
                  const SizedBox(height: 20),

                  /// Reason
                  Row(
                    children: const [
                      Text(
                        "Reason for Cancellation",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(" *", style: TextStyle(color: Colors.red)),
                      Spacer(),
                      Text(
                        "Required Field",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  buildTextField(
                    hint: "Enter the reason provided by the customer...",
                    controller: reasonController,
                    isError: showError,
                  ),

                  if (showError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Reason for cancellation is required.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 20),

                  /// Notes
                  const Text(
                    "Additional Notes (Optional)",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  buildTextField(
                    hint: "Add any internal notes or context (optional).",
                    controller: notesController,
                  ),

                  const SizedBox(height: 30),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Submit Request →",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize: Size(MediaQuery.sizeOf(context).width, 40),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Discard Changes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
