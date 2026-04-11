import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';

const Color primary = Color(0xFF1BA39C);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int pending = 0;
  int running = 0;
  int quotation = 0;
  int completed = 0;

  List tasks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  /// 🔽 API CALL
  Future<void> fetchDashboard() async {
    try {
      final uri = Uri.parse("$baseUrl/dashboard");

      final response = await http.get(uri);

      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          pending = data['counts']['pending'];
          running = data['counts']['running'];
          quotation = data['counts']['quotation'];
          completed = data['counts']['completed'];

          tasks = data['tasks'];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard error: $e");
    }
  }

  /// 🔷 STATUS CARD
  Widget statusCard(String title, int count, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("$count",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(title,
                  style: TextStyle(fontSize: 11, color: color)),
            ],
          )
        ],
      ),
    );
  }

  /// 🔷 TASK CARD
  Widget taskCard(Map task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(task['code'] ?? ""),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task['department'] ?? "",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            task['title'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.circle_outlined, size: 14, color: primary),
              const SizedBox(width: 5),
              Text(
                task['status'] ?? "Unassigned",
                style: const TextStyle(color: primary),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text("Assign"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔷 HEADER
              const Text(
                "Work Status",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              const Text(
                "Shree Krishna Ads • April 05, 2026",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 15),

              /// 🔷 STATUS GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  statusCard("PENDING", pending, Colors.teal, Icons.person),
                  statusCard("RUNNING", running, Colors.blue, Icons.work),
                  statusCard("QUOTATION", quotation, Colors.orange, Icons.description),
                  statusCard("COMPLETED", completed, Colors.green, Icons.check_circle),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔷 TASK BOARD HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Task Board",
                      style:
                      TextStyle(fontWeight: FontWeight.w600)),
                  Text("See all",
                      style: TextStyle(color: primary)),
                ],
              ),

              const SizedBox(height: 10),

              /// 🔷 TASK LIST
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) => taskCard(tasks[i]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}