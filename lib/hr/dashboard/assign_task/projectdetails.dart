import 'package:flutter/material.dart';
import 'assign_task.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Project Detail",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text("PRJ-2024-089",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        actions: const [
          Icon(Icons.edit, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.close, color: Colors.red),
          SizedBox(width: 10),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignTaskPage(
                projectId: widget.projectId,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("ID: PRJ-2024-089",
                            style: TextStyle(color: Colors.teal)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: const Text("Designing",
                              style: TextStyle(color: Colors.teal)),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Summer Launch Campaign",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Customer: Global Systems Inc.",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SERVICE TYPE",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("Digital Marketing"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("DEADLINE",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("Apr 30, 2026",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.layers, color: Colors.teal),
                    SizedBox(width: 6),
                    Text("Task Details (2)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Text("View All",
                    style: TextStyle(color: Colors.teal)),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("PRJ-2024-089",
                          style: TextStyle(color: Colors.grey)),
                      Text("In Progress",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text("Designing",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                  const SizedBox(height: 6),

                  const Text(
                    "Set up the high-availability server clusters across three geographic zones to ensure 99.99% uptime.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const Divider(height: 20),

                  Row(
                    children: const [
                      Icon(Icons.error_outline,
                          size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text("High"),
                      SizedBox(width: 15),
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text("Oct 24"),
                      Spacer(),
                      Icon(Icons.attach_file, size: 16),
                      SizedBox(width: 4),
                      Text("4"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sarah Chen"),
                            Text("Subtasks: 65%",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: LinearProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.teal,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.person_add_alt_1_outlined),
                      Icon(Icons.edit_outlined),
                      Icon(Icons.chat_bubble_outline),
                      Icon(Icons.check_circle_outline),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}