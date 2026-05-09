import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ska_crm/teams/pages/dashboard/dashboard.dart';
import '../../../provider/provider.dart';
import '../../../utils/config.dart';
import 'completed_detailed_task.dart';
import 'in_completed_detailed_task.dart';

Future<List<TaskCard>>? completedTasksFuture;
List<dynamic> completedTasks = [];
dynamic completedTasksCount;
List<dynamic> incompleteTasks = [];
dynamic incompleteTasksCount;
Future<List<TaskCard>>? incompleteTasksFuture;
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  Future<List<TaskCard>> fetchCompletedTasks() async{
    final pref = await SharedPreferences.getInstance();
    final phone = pref.get('phone');
    print('entered');
    final url = Uri.parse('$baseUrl/users/team/completed_tasks/$phone');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    //print(response.statusCode);
    if(response.statusCode == 200) {
      List<dynamic> completedTasks = jsonDecode(response.body);
      setState(() {
        completedTasksCount = completedTasks.length;
      });
      //print(completedTasks);
      List<TaskCard> completedTaskWidgets = completedTasks.map((task) {
        return (TaskCard(
          taskId: task['id'],
          title: task['title'],
          subtitle: task['description'] ?? 'no description',
          id: task['project']['project_code'],
          date: DateFormat('MMMM d, y').format(DateTime.parse(task['due_at'])),
          status: task['status'],
          isDelayed: DateTime.parse(task['due_at']).isBefore(DateTime.now()),
        ));
      },).toList();
      return completedTaskWidgets;
    }
    else {
      return [];
    }
  }

  Future<List<TaskCard>> fetchInCompleteTasks() async{
    final pref = await SharedPreferences.getInstance();
    final phone = pref.get('phone');
    print('entered');
    final url = Uri.parse('$baseUrl/users/team/incomplete_tasks/$phone');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if(response.statusCode == 200) {
      List<dynamic> incompleteTasks = jsonDecode(response.body);
      setState(() {
        incompleteTasksCount = incompleteTasks.length;
      });
      List<TaskCard> incompleteTaskWidgets = incompleteTasks.map((task) {
        print(task);
        return (TaskCard(
          taskId: task['id'],
          title: task['title'],
          subtitle: task['description'] ?? 'no description',
          id: task['project']['project_code'],
          date: DateFormat('MMMM d, y').format(DateTime.parse(task['due_at'])),
          status: task['status'],
          isDelayed: DateTime.parse(task['due_at']).isBefore(DateTime.now()),
        ));
      },).toList();
      return incompleteTaskWidgets;
    }
    else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      setState(() {
        completedTasksFuture = fetchCompletedTasks();
        incompleteTasksFuture = fetchInCompleteTasks();
      });
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        final hasInternet = results.any((r) => r != ConnectivityResult.none);
        if (hasInternet) {
          setState(() {
            completedTasksFuture = fetchInCompleteTasks();
            incompleteTasksFuture = fetchInCompleteTasks();
          });
        }
      });
    }

  }

  Widget completed() {
    return Column(
      children: [
        SectionHeaderCompleted(),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              FutureBuilder<List<TaskCard>>(
                  future: completedTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    completedTasks = snapshot.data!;

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          final completedTask = completedTasks[index];
                          return completedTask;
                        }
                    );
                  }
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget incompleted() {
    return Column(
      children: [
        SectionHeaderInCompleted(),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children:  [
              FutureBuilder<List<TaskCard>>(
                  future: incompleteTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    incompleteTasks = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: incompleteTasks.length,
                        itemBuilder: (context, index) {
                          final incompleteTask = incompleteTasks[index];
                          return incompleteTask;
                        }
                    );
                  }
              ),

            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const ToggleTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: Provider.of<TaskProvider>(context).isCompletedSelected
                  ? completed()
                  : incompleted(),
            ),
          ],
        ),
      ),
    );
  }
}





class ToggleTabs extends StatelessWidget {
  const ToggleTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              taskProvider.setCompleted(false);
            },
            child: Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width / 2.3,

              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: taskProvider.isCompletedSelected
                    ? Colors.white
                    : Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      color: taskProvider.isCompletedSelected
                          ? Colors.grey
                          : Colors.teal,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Incomplete",
                      style: TextStyle(
                        color: taskProvider.isCompletedSelected
                            ? Colors.grey
                            : Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              taskProvider.setCompleted(true);
            },
            child: Container(
              height: 50,
              width: MediaQuery.sizeOf(context).width / 2.3,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: taskProvider.isCompletedSelected
                    ? Colors.teal.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: taskProvider.isCompletedSelected
                          ? Colors.teal
                          : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Complete",
                      style: TextStyle(
                        color: taskProvider.isCompletedSelected
                            ? Colors.teal
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeaderInCompleted extends StatelessWidget {
  const SectionHeaderInCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "INCOMPLETE TASKS (${incompleteTasksCount ?? '-'})",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Auto-Updated",
            style: TextStyle(color: Colors.teal, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class SectionHeaderCompleted extends StatelessWidget {
  const SectionHeaderCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "COMPLETED TASKS (${completedTasksCount ?? '-'})",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Auto-Updated",
            style: TextStyle(color: Colors.teal, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskId;
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final bool isDelayed;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    this.isDelayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (status.toUpperCase() != "COMPLETED") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => InCompletedTaskDetailsScreen(taskId: taskId)),
          );
        }
        if (status.toUpperCase() == "COMPLETED") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CompletedTaskDetailsScreen( taskId: taskId,)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (isDelayed)
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.red, size: 15),
                      SizedBox(width: 4),
                      const Text(
                        "DELAYED",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.assignment_outlined),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.red,
                  child: Text(
                    "9",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          label: "My Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}
