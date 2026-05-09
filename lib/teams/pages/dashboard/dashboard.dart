import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';
import 'package:intl/intl.dart';

import '../my_tasks/completed_detailed_task.dart';
import '../my_tasks/in_completed_detailed_task.dart';

dynamic totalTaskCount;
dynamic pendingTaskCount;
dynamic inProgressTaskCount;
dynamic completedTaskCount;
dynamic delayedTaskCount;
dynamic inCompleteTaskCount;
late Future<List<TaskCard>> activeTasksFuture;

class Dashboard extends StatefulWidget {
  final Function(int) switchPage;
  const Dashboard({
    super.key,
    required this.switchPage
  });
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  Future<void> loadCount() async {
    final pref = await SharedPreferences.getInstance();
    final phone = pref.get('phone');
    final url = Uri.parse('$baseUrl/users/team/task_type_count/$phone');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> countData = jsonDecode(response.body);
      print(countData);

      setState(() {
        totalTaskCount = countData['total_task_count']!;
        completedTaskCount = countData['completed_task_count']!;
        pendingTaskCount = countData['pending_task_count']!;
        inProgressTaskCount = countData['in_progress_task_count']!;
        delayedTaskCount = countData['delayed_task_count']!;
        inCompleteTaskCount = countData['incomplete_task_count']!;
      });
    }
    else {

    }
  }

  Future<List<TaskCard>> fetchActiveTasks() async {
    final pref = await SharedPreferences.getInstance();
    final phone = pref.get('phone');
    final url = Uri.parse('$baseUrl/users/team/active_tasks/$phone');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(response.statusCode == 200) {
      List<dynamic>  activeTasks = jsonDecode(response.body);
      List<TaskCard> activeTaskWidgets = [
        TaskCard(
                 taskId: activeTasks[0]['id'],
                 id: activeTasks[0]['project']['project_code'],
                 title: activeTasks[0]['title'],
                 status: activeTasks[0]['status'],
                 deadline: DateFormat('MMMM d, y').format(DateTime.parse(activeTasks[2]['due_at'])),
                 isDelayed: DateTime.parse(activeTasks[0]['due_at']).isBefore(DateTime.now())
        ),
        TaskCard(
            taskId: activeTasks[1]['id'],
            id: activeTasks[1]['project']['project_code'],
            title: activeTasks[1]['title'],
            status: activeTasks[1]['status'],
            deadline: DateFormat('MMMM d, y').format(DateTime.parse(activeTasks[2]['due_at'])),
            isDelayed: DateTime.parse(activeTasks[0]['due_at']).isBefore(DateTime.now())
        ),
        TaskCard(
            taskId: activeTasks[2]['id'],
            id: activeTasks[2]['project']['project_code'],
            title: activeTasks[2]['title'],
            status: activeTasks[2]['status'],
            deadline: DateFormat('MMMM d, y').format(DateTime.parse(activeTasks[2]['due_at'])),
            isDelayed: DateTime.parse(activeTasks[0]['due_at']).isBefore(DateTime.now())
        )
      ];
      return activeTaskWidgets;
    }
    else {
      return [];
    }
}

  @override
  void initState() {
    super.initState();
    loadCount();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        loadCount();
      }
    });
    setState(() {
      activeTasksFuture = fetchActiveTasks();

      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        final hasInternet = results.any((r) => r != ConnectivityResult.none);
        if (hasInternet) {
          activeTasksFuture = fetchActiveTasks();
        }
      });

    });
  }
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
            FutureBuilder<List<TaskCard>>(
                future: activeTasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Center(child: Text('something went wrong'));
                  }
                  final activeTasks = snapshot.data!;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: activeTasks.length,
                      itemBuilder: (context, index) {
                        final activeTask = activeTasks[index];
                        return activeTask;
                      }
                  );
                }
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
            "Shree Krishna Ads • ${DateFormat('MMMM d, y').format(DateTime.now())} ",
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
            children: [
              StatusCard(
                totalTaskCount != null ? totalTaskCount.toString() : '-',
                "TOTAL TASKS",
                Colors.teal,
                icon: Icons.event_note,
              ),
               StatusCard(
                 pendingTaskCount != null ? pendingTaskCount.toString() : '-',
                "PENDING",
                Colors.blueGrey,
                icon: CupertinoIcons.clock,
              ),
              StatusCard(
                inProgressTaskCount != null ? inProgressTaskCount.toString() : '-',
                "IN PROGRESS",
                Colors.brown,
                icon: CupertinoIcons.play,
              ),
              StatusCard(
                completedTaskCount != null ? completedTaskCount.toString() : '-',
                "COMPLETED",
                Colors.green,
                icon: Icons.check_circle_outline,
              ),
              StatusCard(delayedTaskCount != null ? delayedTaskCount.toString() : '-', "DELAYED", Colors.red, icon: Icons.access_time),
              StatusCard(inCompleteTaskCount != null ? inCompleteTaskCount.toString() : '-', "INCOMPLETE", Colors.orange, icon: Icons.close),
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
            onPressed: () {
              widget.switchPage(1);
            },
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
  final String taskId;
  final String id;
  final String title;
  final String status;
  final String deadline;
  final bool isDelayed;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.id,
    required this.title,
    required this.status,
    required this.deadline,
    required this.isDelayed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (status.toUpperCase() != "COMPLETED") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => InCompletedTaskDetailsScreen(taskId: taskId)),
            );
          }
          if (status.toUpperCase() == "COMPLETED") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CompletedTaskDetailsScreen(taskId: taskId,)),
            );
          }
        },
        child: Container(
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
                  side: BorderSide(color: Colors.teal, width: 2),
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
    )
    );
  }
}

