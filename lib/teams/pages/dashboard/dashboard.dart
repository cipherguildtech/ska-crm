import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildActiveTasksHeader(),
            const SizedBox(height: 10),

            TaskCard(
              id: "SKA-7721",
              title: "Shop Flex Banner Design",
              status: "In Progress",
              deadline: "Today, 4:00 AM",
              isDelayed: false,
            ),
            TaskCard(
              id: "SKA-7690",
              title: "Poster Design",
              status: "Pending",
              deadline: "Yesterday, 5:00 PM",
              isDelayed: true,
            ),
            TaskCard(
              id: "SKA-7804",
              title: "Material Quality Check",
              status: "Pending",
              deadline: "Apr 26, 11:00 AM",
              isDelayed: false,
            ),

            const SizedBox(height: 10),
            const Text(
              "UPDATED 2 MINS AGO • HIGH CONTRAST MODE ACTIVE",
              style: TextStyle(fontSize: 11, color: Colors.teal),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Work Status",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Shree Krishna Ads • April 05, 2026",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.8,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              StatusCard(
                "24",
                "TOTAL TASKS",
                Colors.teal,
                icon: Icons.event_note,
              ),
              StatusCard(
                "08",
                "PENDING",
                Colors.blueGrey,
                icon: CupertinoIcons.clock,
              ),
              StatusCard(
                "04",
                "IN PROGRESS",
                Colors.brown,
                icon: CupertinoIcons.play,
              ),
              StatusCard(
                "12",
                "COMPLETED",
                Colors.green,
                icon: Icons.check_circle_outline,
              ),
              StatusCard("02", "DELAYED", Colors.red, icon: Icons.access_time),
              StatusCard("12", "INCOMPLETE", Colors.orange, icon: Icons.close),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTasksHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            "Active Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text("View All", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final IconData icon;
  const StatusCard(
    this.count,
    this.label,
    this.color, {
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              Spacer(),
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final String deadline;
  final bool isDelayed;

  const TaskCard({
    super.key,
    required this.id,
    required this.title,
    required this.status,
    required this.deadline,
    required this.isDelayed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text("ID: $id"),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: primary, width: 2),
                ),
              ),
              const Spacer(),
              Chip(
                label: Text(status),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: status == "In Progress" ? Colors.black : Colors.red,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDelayed ? Colors.red[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: isDelayed ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  "Deadline: $deadline",
                  style: TextStyle(color: isDelayed ? Colors.red : Colors.grey),
                ),
                if (isDelayed) ...[
                  const Spacer(),
                  const Chip(
                    label: Text(
                      "DELAYED",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
