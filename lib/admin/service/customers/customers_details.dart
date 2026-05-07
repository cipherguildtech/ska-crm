import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Customer Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const CustomerCard(),
            const SizedBox(height: 20),

            /// Projects Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Projects (4)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("View History", style: TextStyle(color: Colors.teal)),
              ],
            ),
            const SizedBox(height: 12),

            /// Project Cards
            ProjectCard(
              id: "SKA-2025-0042",
              title: "Full Home Renovation",
              deadline: "Oct 15, 2025",
              status: "Active",
            ),
            ProjectCard(
              id: "SKA-2025-0108",
              title: "Kitchen Interior Design",
              deadline: "Aug 22, 2025",
              status: "Completed",
            ),
            ProjectCard(
              id: "SKA-2024-0988",
              title: "Backyard Landscaping",
              deadline: "May 10, 2025",
              status: "Cancelled",
            ),
            ProjectCard(
              id: "SKA-2025-1152",
              title: "Electrical Rewiring",
              deadline: "Dec 05, 2025",
              status: "Active",
            ),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                "END OF RECORDS",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.teal.withOpacity(0.1),
            child: const Icon(Icons.person, color: Colors.teal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Alexandros Sterling",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("Premium Client", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text("+1 (555) 012-3456"),
                Text("742 Evergreen Terrace, Springfield"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String id;
  final String title;
  final String deadline;
  final String status;

  const ProjectCard({
    super.key,
    required this.id,
    required this.title,
    required this.deadline,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case "Active":
        return Colors.teal;
      case "Completed":
        return Colors.grey;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: getStatusColor())),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Title
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

          const SizedBox(height: 8),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Deadline: $deadline",
                style: const TextStyle(color: Colors.grey),
              ),
              const Text("Details", style: TextStyle(color: Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }
}
