import 'package:flutter/material.dart';
import 'widgets/task_filter.dart';
import '../../services/teams.dart';
import 'widgets/profile_card.dart';
import 'widgets/task_card.dart';

class Detail extends StatefulWidget {
  final String phone;

  const Detail({
    super.key,
    required this.phone,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? responseData;
  String selectedFilter = "ALL";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final data = await TeamService.fetchTeamsDetails(widget.phone);

      setState(() {
        responseData = data;
        user = data["user"];
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(dynamic date) {
    if (date == null) return "-";

    return date.toString().split("T")[0];
  }

  String? safeText(dynamic value) {
    if (value == null) return null;

    if (value is String && value.trim().isEmpty) return null;

    if (value is List && value.isEmpty) return null;

    if (value.toString() == "null") return null;

    return value.toString();
  }

  List get filteredTasks {
    final List tasks = user?["assigned_tasks"] ?? [];

    if (selectedFilter == "ALL") return tasks;

    return tasks.where((task) {
      return (task["status"] ?? "").toString().toUpperCase() ==
          selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        ),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No Data Found"),
        ),
      );
    }

    final List tasks = user?["assigned_tasks"] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Staff Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ProfileCard(
              user: user,
              responseData: responseData,
            ),

            const SizedBox(height: 20),

            Text(
              "Task Details (${tasks.length})",

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TaskFilterBar(
              selectedFilter: selectedFilter,
              onChanged: (v) => setState(() => selectedFilter = v),
            ),
            const SizedBox(height: 15),
            if (filteredTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    "No tasks found",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...filteredTasks.map((task) {
                return TaskCard(
                  task: task,
                  formatDate: formatDate,
                );
              }),
          ],
        ),
      ),
    );
  }
}