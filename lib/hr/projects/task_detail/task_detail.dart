import 'package:flutter/material.dart';
import '../../teams/details/task_details/widgets/task_card.dart';
import '../../teams/details/task_details/widgets/quotation_card.dart';
import '../../teams/details/task_details/widgets/task_history.dart';

class CommonTaskPage extends StatefulWidget {
  final Map task;

  const CommonTaskPage({super.key, required this.task});

  @override
  State<CommonTaskPage> createState() => _CommonTaskPageState();
}

class _CommonTaskPageState extends State<CommonTaskPage> {
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

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    final List history = List.from(task['taskHistory'] ?? []);
    final List quotations = List.from(task['quotations'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      appBar: AppBar(
        title: const Text("Task Detail"),
        backgroundColor: Colors.teal,
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