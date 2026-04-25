import 'package:flutter/material.dart';
import 'package:ska_crm/hr/projects/projectdetails.dart';

class Projects extends StatelessWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "All Projects",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {},
              ),
              const Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
              )
            ],
          )
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by ID or customer...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildChip("All", true),
                buildChip("Active", false),
                buildChip("Pending", false),
                buildChip("Completed", false),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("ALL PROJECTS (4)",
                    style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Text("Sort By", style: TextStyle(color: Colors.teal)),
                    Icon(Icons.chevron_right, color: Colors.teal)
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          // List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ProjectCard(
                  id: "PRJ-2026-042",
                  title: "Acme Retail",
                  subtitle: "Social Media Campaign",
                  stage: "Stage 4 of 9",
                  progress: 0.4,
                  date: "Apr 28, 2026",
                  status: "Active",
                ),
                ProjectCard(
                  id: "PRJ-2026-037",
                  title: "BrightMart",
                  subtitle: "Website Refresh",
                  stage: "Stage 2 of 9",
                  progress: 0.2,
                  date: "May 04, 2026",
                  status: "Pending",
                ),
                ProjectCard(
                  id: "PRJ-2026-010",
                  title: "HealthPlus",
                  subtitle: "PPC Campaign",
                  stage: "Stage 9 of 9",
                  progress: 1,
                  date: "Mar 30, 2026",
                  status: "Completed",
                  isOverdue: true,
                ),
                ProjectCard(
                  id: "PRJ-2026-055",
                  title: "TechNova",
                  subtitle: "Brand Identity",
                  stage: "Stage 6 of 12",
                  progress: 0.5,
                  date: "Jun 12, 2026",
                  status: "Active",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget buildChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.teal.withOpacity(0.2),
        labelStyle:
        TextStyle(color: selected ? Colors.teal : Colors.grey),
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? Colors.teal : Colors.grey.shade300,
          ),
        ),
        onSelected: (_) {},
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String stage;
  final double progress;
  final String date;
  final String status;
  final bool isOverdue;

  const ProjectCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.stage,
    required this.progress,
    required this.date,
    required this.status,
    this.isOverdue = false,
  });

  Color getStatusColor() {
    switch (status) {
      case "Active":
        return Colors.blue;
      case "Pending":
        return Colors.grey;
      case "Completed":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailsPage(),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: const TextStyle(color: Colors.grey)),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: getStatusColor()),
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),

            Text(title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 10),
            const Divider(),

            const SizedBox(height: 10),

            // Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(stage,
                          style: const TextStyle(color: Colors.teal)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14,
                        color: isOverdue ? Colors.red : Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: TextStyle(
                        color: isOverdue ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ),
    );
  }
}