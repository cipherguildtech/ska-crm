import 'package:flutter/material.dart';

import 'staff_details_page.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Center Header Title
              const Center(
                child: Text(
                  "Teams Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name or department",
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

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    buildChip("All", true),
                    buildChip("Available", false),
                    buildChip("Busy", false),
                    buildChip("Overdue", false),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "ALL STAFFS (40)",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Text(
                          "Sort By",
                          style: TextStyle(color: Colors.teal),
                        ),
                        Icon(Icons.chevron_right, color: Colors.teal)
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Staff List (no Expanded!)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    StaffCard(
                      name: "Sarah Jenkins",
                      role: "Senior UI Designer • Creative",
                      status: "AVAILABLE",
                      tasks: 2,
                      statusColor: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StaffDetailPage(),
                          ),
                        );
                      },
                    ),

                    StaffCard(
                      name: "Michael Chen",
                      role: "Fullstack Developer • Engineering",
                      status: "BUSY",
                      tasks: 5,
                      statusColor: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StaffDetailPage(),
                          ),
                        );
                      },
                    ),

                    StaffCard(
                      name: "Elena Rodriguez",
                      role: "Project Manager • Operations",
                      status: "OVERLOADED",
                      tasks: 12,
                      statusColor: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StaffDetailPage(),
                          ),
                        );
                      },
                    ),

                    StaffCard(
                      name: "David Smith",
                      role: "Backend Architect • Engineering",
                      status: "AVAILABLE",
                      tasks: 1,
                      statusColor: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StaffDetailPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // space for FAB
            ],
          ),
        ),
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
        labelStyle: TextStyle(
          color: selected ? Colors.teal : Colors.grey,
        ),
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

class StaffCard extends StatelessWidget {
  final String name;
  final String role;
  final String status;
  final int tasks;
  final Color statusColor;
  final VoidCallback? onTap; // 👈 ADD THIS

  const StaffCard({
    super.key,
    required this.name,
    required this.role,
    required this.status,
    required this.tasks,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell( // 👈 WRAP WITH INKWELL
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.teal.withOpacity(0.1),
            child: const Icon(Icons.person, color: Colors.teal),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (status == "OVERLOADED")
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(status, style: TextStyle(color: statusColor)),
                ],
              )
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$tasks Tasks",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}