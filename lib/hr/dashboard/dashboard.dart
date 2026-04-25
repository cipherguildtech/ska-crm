import 'package:flutter/material.dart';
import '../services/dashboard.dart';
import 'widgets/status_card.dart';
import 'widgets/filter_tabs.dart';
import 'widgets/task_card.dart';
import 'widgets/team_availability.dart';

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
  int selectedFilter = 0;
  List tasks = [];
  List teams = [];
  List toAssign = [];
  List inProgressList = [];
  List inReview = [];
  bool isLoading = true;
  int completedTasks = 0;
  int cancelled = 0;
  int review = 0;
  int incompleteTasks = 0;
  int draftQuotation = 0;
  int sentQuotation = 0;
  int approvedQuotation = 0;
  int rejectedQuotation = 0;
  int projectWithoutTask = 0;

  final DashboardService _dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  List get currentTasks {
    if (selectedFilter == 0) return toAssign;
    if (selectedFilter == 1) return inProgressList;
    return inReview;
  }

  Future<void> fetchDashboard() async {
    setState(() => isLoading = true);

    final response = await _dashboardService.fetchDashboard();

    if (response["success"]) {
      final data = response["data"];

      setState(() {
        pending = data['pendingTasks'] ?? 0;
        inProgress = data['inProgressTasks'] ?? 0;
        completedTasks = data['completedTasks'] ?? 0;
        cancelled = data['cancelledTasks'] ?? 0;
        review = data['reviewTasks'] ?? 0;
        delayed = data['delayedTasks'] ?? 0;
        incompleteTasks = data['incompleteTasks'] ?? 0;

        draftQuotation = data['draftQuotation'] ?? 0;
        sentQuotation = data['sentQuotation'] ?? 0;
        approvedQuotation = data['approvedQuotation'] ?? 0;
        rejectedQuotation = data['rejectedQuotation'] ?? 0;

        completed = data['completedProjects'] ?? 0;
        incomplete = data['notCompletedProjects'] ?? 0;
        projectWithoutTask = data['projectWithoutAnyTask'] ?? 0;

        toAssign = data['tasksToAssign'] ?? [];
        inProgressList = data['taskInProgress'] ?? [];
        inReview = data['taskForReview'] ?? [];
        teams = data['teams'] ?? [];

        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);

      _showMessage(
        response["message"] ?? "Failed to load dashboard",
        isError: true,
      );
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 13),
        ),
        backgroundColor: isError ? Colors.red : primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: const Duration(seconds: 2),
        elevation: 6,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Work Status",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal, ),
              ),

              const SizedBox(height: 4),

              Text(
                "Shree Krishna Ads • ${todayDate()}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 15),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 2.0,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatusCard(
                    title: "No Task Projects",
                    count: projectWithoutTask,
                    color: Colors.brown,
                    icon: Icons.block,
                  ),
                  StatusCard(
                    title: "Review",
                    count: review,
                    color: Colors.purple,
                    icon: Icons.rate_review,
                  ),
                  StatusCard(
                    title: "Pending",
                    count: pending,
                    color: Colors.teal,
                    icon: Icons.pending,
                  ),
                  StatusCard(
                    title: "In Progress",
                    count: inProgress,
                    color: Colors.blue,
                    icon: Icons.work,
                  ),
                  StatusCard(
                    title: "Incomplete Tasks",
                    count: incompleteTasks,
                    color: Colors.black54,
                    icon: Icons.error,
                  ),
                  StatusCard(
                    title: "Completed Tasks",
                    count: completedTasks,
                    color: Colors.green,
                    icon: Icons.check,
                  ),
                  StatusCard(
                    title: "Cancelled",
                    count: cancelled,
                    color: Colors.red,
                    icon: Icons.cancel,
                  ),
                  StatusCard(
                    title: "Delayed",
                    count: delayed,
                    color: Colors.orange,
                    icon: Icons.warning,
                  ),
                  StatusCard(
                    title: "Draft Quote",
                    count: draftQuotation,
                    color: Colors.grey,
                    icon: Icons.description,
                  ),
                  StatusCard(
                    title: "Sent Quote",
                    count: sentQuotation,
                    color: Colors.blueGrey,
                    icon: Icons.send,
                  ),
                  StatusCard(
                    title: "Approved Quote",
                    count: approvedQuotation,
                    color: Colors.green,
                    icon: Icons.thumb_up,
                  ),
                  StatusCard(
                    title: "Rejected Quote",
                    count: rejectedQuotation,
                    color: Colors.red,
                    icon: Icons.thumb_down,
                  ),
                  StatusCard(
                    title: "Completed Projects",
                    count: completed,
                    color: Colors.green,
                    icon: Icons.done_all,
                  ),
                  StatusCard(
                    title: "Incomplete Projects",
                    count: incomplete,
                    color: Colors.black54,
                    icon: Icons.close,
                  ),

                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Task Board", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),

              const SizedBox(height: 10),

              FilterTabs(
                selectedIndex: selectedFilter,
                onChanged: (index) {
                  setState(() {
                    selectedFilter = index;
                  });
                },
                toAssignCount: toAssign.length,
                inProgressCount: inProgressList.length,
                reviewCount: inReview.length,
              ),

              const SizedBox(height: 10),

              /// TASK LIST (NO ListView!)
              if (currentTasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text("No tasks available", style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                Column(
                  children: currentTasks
                      .map<Widget>((task) => TaskCard(task: task))
                      .toList(),
                ),

              const SizedBox(height: 10),

              TeamAvailability(teams: teams),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}