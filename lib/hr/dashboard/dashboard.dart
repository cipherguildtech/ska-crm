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
  int quotation = 0;
  int completed = 0;
  int inProgress = 0;
  int delayed = 0;
  int incomplete = 0;
  int selectedFilter = 0; // 0 = To Assign, 1 = In Progress, 2 = In Review
  List tasks = [];
  List teams = [];
  List toAssign = [];
  List inProgressList = [];
  List inReview = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchDashboard();
  // }
  @override
  void initState() {
    super.initState();
    fetchDashboard(); // 👈 instead of API
  }

  List get currentTasks {
    if (selectedFilter == 0) return toAssign;
    if (selectedFilter == 1) return inProgressList;
    return inReview;
  }
  /// 🔽 API CALL
  Future<void> fetchDashboard() async {
    try {
      final uri = Uri.parse("$baseUrl/tasks/hr_dashboard");

      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      setState(() {
        /// 🔷 COUNTS
        pending = data['pendingTasks'] ?? 0;
        inProgress = data['inProgressTasks'] ?? 0;
        delayed = data['delayedTasks'] ?? 0;

        /// QUOTATION (sum all)
        quotation =
            (data['draftQuotation'] ?? 0) +
                (data['sentQuotation'] ?? 0) +
                (data['approvedQuotation'] ?? 0);

        completed = data['completedProjects'] ?? 0;
        incomplete = data['notCompletedProjects'] ?? 0;

        /// 🔷 TASK LISTS
        inProgressList = List<Map<String, dynamic>>.from(
          data['taskInProgress'] ?? [],
        );

        inReview = List<Map<String, dynamic>>.from(
          data['taskForReview'] ?? [],
        );

        /// OPTIONAL (if backend gives later)
        toAssign = List<Map<String, dynamic>>.from(
          data['taskToAssign'] ?? [],
        );

        /// 🔷 TEAMS
        teams = List<Map<String, dynamic>>.from(
          data['teams'] ?? [],
        );

        isLoading = false;
      });
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

  Widget filterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          filterItem("To Assign (${toAssign.length})", 0),
          filterItem("In Progress (${inProgressList.length})", 1),
          filterItem("In Review (${inReview.length})", 2),
        ],
      ),
    );
  }

  Widget teamAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Team Availability",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => TeamDetailsPage(teams: teams),
                //   ),
                // );
              },
              child: const Text(
                "See all",
                style: TextStyle(color: primary),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// TEAM LIST
        Column(
          children: teams.map((team) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 10),

                  Text(team['name']),

                  const Spacer(),

                  Text("${team['tasks']} Tasks"),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget filterItem(String title, int index) {
    final isSelected = selectedFilter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? primary : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                child: Text(task['title'] ?? ""),
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

  String todayDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')} "
        "${_monthName(now.month)}, ${now.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[month - 1];
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

              Text(
                "Shree Krishna Ads • ${todayDate()}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                  statusCard("Pending", pending, Colors.teal, Icons.pending),
                  statusCard("Progress", inProgress, Colors.blue, Icons.work),
                  statusCard("Delayed", delayed, Colors.red, Icons.warning),
                  statusCard("Quotation", quotation, Colors.orange, Icons.description),
                  statusCard("Incomplete", incomplete, Colors.grey, Icons.cancel),
                  statusCard("Completed", completed, Colors.green, Icons.check_circle),
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

              filterTabs(),

              const SizedBox(height: 10),
              /// 🔷 TASK LIST
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      /// TASK LIST
                      ListView.builder(
                        itemCount: currentTasks.length,
                        itemBuilder: (_, i) => taskCard(currentTasks[i]),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),

                      /// TEAM AVAILABILITY 👇
                      teamAvailability(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}