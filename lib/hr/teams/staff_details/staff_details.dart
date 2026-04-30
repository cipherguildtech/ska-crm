import 'package:flutter/material.dart';

class StaffDetail extends StatelessWidget {
  final String phone;

  const StaffDetail({
    super.key,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: Column(
          children: const [
            Text("Priya Sharma",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 2),
            Text("Marketing",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 PROFILE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal.withOpacity(0.1),
                        child: const Icon(Icons.person,
                            size: 30, color: Colors.teal),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Senior Designer",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Available for new tasks",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _statCard("ACTIVE TASKS", "04", true),
                      const SizedBox(width: 10),
                      _statCard("COMPLETED", "23", false),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FILTER CHIPS
            Row(
              children: [
                _chip("All", true),
                _chip("Active", false),
                _chip("Overdue", false),
                _chip("Completed", false),
              ],
            ),

            const SizedBox(height: 16),

            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Tasks Portfolio",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Sort", style: TextStyle(color: Colors.teal)),
              ],
            ),

            const SizedBox(height: 10),

            // TASK CARDS
            _taskCard(
              title:
              "Revise landing page copy and optimize CTA button placements",
              status: "Overdue",
              date: "Apr 10, 2026",
              highlight: true,
            ),

            _taskCard(
              title: "Design banner for Summer Sale campaign",
              status: "In Progress",
              date: "Apr 14, 2026",
            ),

            _taskCard(
              title: "Prepare monthly design performance report",
              status: "Completed",
              date: "Mar 30, 2026",
            ),

            _taskCard(
              title: "Audit UI components for accessibility compliance",
              status: "In Progress",
              date: "Apr 20, 2026",
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ---------------- //

  static Widget _statCard(String title, String value, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? Colors.teal.withOpacity(0.15) : Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
          border: active ? Border.all(color: Colors.teal) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(value,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  static Widget _chip(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.teal.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.teal : Colors.grey,
        ),
      ),
    );
  }

  static Widget _taskCard({
    required String title,
    required String status,
    required String date,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: highlight
            ? const Border(left: BorderSide(color: Colors.red, width: 3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("PRJ-2026-XXX",
                  style: TextStyle(color: Colors.grey)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "Overdue"
                      ? Colors.red.withOpacity(0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      color:
                      status == "Overdue" ? Colors.red : Colors.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("2 Subtasks",
                  style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(date),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}