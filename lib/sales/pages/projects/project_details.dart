import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ska_crm/sales/pages/projects/quotation.dart';
import 'package:ska_crm/sales/pages/projects/update_quotation.dart';

import '../../sales_service.dart';
import 'cancel_quotation.dart';

class ProjectDashboard extends StatefulWidget {
  final String code;
  const ProjectDashboard({super.key, required this.code});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.code, style: TextStyle(color: Colors.black)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project['status'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            Text(
              "Project Dashboard",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomerInfoCard(project: project),
            const SizedBox(height: 16),
            ProjectDetailsCard(project: project),
            const SizedBox(height: 16),
            ActionButtons(project: project),
            const SizedBox(height: 16),
            ProjectSummary(project: project),
          ],
        ),
      ),
    );
  }
}

class CustomerInfoCard extends StatelessWidget {
  final Map<String, dynamic> project;
  const CustomerInfoCard({super.key, required this.project});

  Widget item(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00A8A8).withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  "CUSTOMER INFO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const Divider(),
            item(Icons.person, "PRIMARY CONTACT", project['customer']['name']),
            item(Icons.phone, "CONTACT NUMBER", project['customer']['phone']),
            item(Icons.email_outlined, "EMAIL", project['customer']['email']),
            item(
              Icons.location_on,
              "SITE ADDRESS",
              project['customer']['address'],
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsCard extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectDetailsCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(project['deadline'].toString());
    final deadline =
        '${DateFormat('MMMM').format(date)} ${date.day}, ${date.year}';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "PROJECT DETAILS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SERVICE TYPE",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.teal, size: 15),
                        const SizedBox(width: 5),
                        Text(
                          project['service_type'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "DEADLINE",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.red,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          deadline,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "OBJECTIVE",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            Text(project['description']),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("PROJECT EVOLUTION"),
                Text(
                  "Stage ${project['current_stage']} of 9",
                  style: const TextStyle(color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: int.parse(project['current_stage'].toString()) / 9,
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> project;
  const ActionButtons({super.key, required this.project});

  Widget button(
    Color textColor,
    Color bgColor,
    Color borderColor,
    IconData icon,
    String text,
    context,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (text == "QUOTATION") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuotationsScreen(code: project['project_code']),
              ),
            );
          }
          if (text == "UPDATE PROJECT") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuotationScreen(code: project['project_code']),
              ),
            );
          }
          if (text == "REQUEST CANCEL") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RequestCancellationPage(code: project['project_code']),
              ),
            );
          }
        },

        child: Container(
          height: 75,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              const SizedBox(height: 4),
              Text(
                textAlign: TextAlign.center,
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        button(
          Colors.white,
          Colors.teal,
          Colors.teal,
          Icons.quora,
          "QUOTATION",
          context,
        ),
        button(
          Colors.white,
          Colors.blue,
          Colors.blue,
          Icons.sync,
          "UPDATE PROJECT",
          context,
        ),
        button(
          Colors.red,
          Colors.white,
          Colors.red,
          Icons.cancel_outlined,
          "REQUEST CANCEL",
          context,
        ),
      ],
    );
  }
}

class ProjectSummary extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectSummary({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> tasks = project['tasks'];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Project Summary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "Updated 2h ago",
                //   style: TextStyle(color: Colors.teal, fontSize: 12),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            // Text(
            //   "The structural analysis for SKA-2025-0042 is complete. Material sourcing for high-tensile steel components is currently in progress.",
            // ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "UPCOMING TASKS",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                String monthName(int month) {
                  const months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ];

                  return months[month - 1];
                }

                final task = tasks[index];
                final due = DateTime.parse(task['due_at'].toString());
                final now = DateTime.now();

                final today = DateTime(now.year, now.month, now.day);
                final dueDate = DateTime(due.year, due.month, due.day);
                final quotations = task['quotations'];

                return ListTile(
                  leading: Icon(
                    Icons.circle,
                    size: 10,
                    color:
                        quotations.isNotEmpty &&
                            quotations[0]['approval_status'] == "SENT"
                        ? Colors.blue
                        : Colors.orange,
                  ),
                  title: Text(task['title']),
                  trailing: Text(
                    dueDate == today
                        ? "Today"
                        : dueDate == today.add(const Duration(days: 1))
                        ? "Tomorrow"
                        : "${monthName(due.month)} ${due.day}, ${due.year}",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
