import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/provider.dart';
import 'completed_detailed_task.dart';
import 'in_completed_detailed_task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
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

Widget completed() {
  return Column(
    children: [
      const SectionHeaderInCompleted(),
      const SizedBox(height: 12),
      Expanded(
        child: ListView(
          children: const [
            TaskCard(
              id: "SKA-2025-0042",
              title: "Shop Flex Banner Design",
              subtitle: "Design flex banner for Ravi Stores opening",
              date: "Apr 24, 2026 • 01:00",
              status: "Completed",
            ),
            TaskCard(
              id: "SKA-2025-0045",
              title: "LED Board Layout Design",
              subtitle: "Create LED layout for showroom front",
              date: "Apr 02, 2026 • 09:00",
              status: "Completed",
              isDelayed: true,
            ),
            TaskCard(
              id: "SKA-2025-0048",
              title: "Poster Design",
              subtitle: "Design promotional poster for festival sale",
              date: "Apr 28, 2026 • 01:30",
              status: "Completed",
            ),
            TaskCard(
              id: "SKA-2025-0051",
              title: "Visiting Card Design",
              subtitle: "Design visiting card for client ABC Traders",
              date: "Oct 30, 2025 • 10:00",
              status: "Completed",
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
      const SectionHeaderCompleted(),
      const SizedBox(height: 12),
      Expanded(
        child: ListView(
          children: const [
            TaskCard(
              id: "SKA-2025-0042",
              title: "Shop Flex Banner Design",
              subtitle: "Design flex banner for Ravi Stores opening",
              date: "Apr 24, 2026 • 01:00",
              status: "In Progress",
            ),
            TaskCard(
              id: "SKA-2025-0045",
              title: "LED Board Layout Design",
              subtitle: "Create LED layout for showroom front",
              date: "Apr 02, 2026 • 09:00",
              status: "Pending",
              isDelayed: true,
            ),
            TaskCard(
              id: "SKA-2025-0048",
              title: "Poster Design",
              subtitle: "Design promotional poster for festival sale",
              date: "Apr 28, 2026 • 01:30",
              status: "Pending",
            ),
            TaskCard(
              id: "SKA-2025-0051",
              title: "Visiting Card Design",
              subtitle: "Design visiting card for client ABC Traders",
              date: "Oct 30, 2025 • 10:00",
              status: "In Progress",
            ),
          ],
        ),
      ),
    ],
  );
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
        const Text(
          "INCOMPLETE TASKS (4)",
          style: TextStyle(
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
        const Text(
          "INCOMPLETE TASKS (4)",
          style: TextStyle(
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
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final bool isDelayed;

  const TaskCard({
    super.key,
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
            MaterialPageRoute(builder: (_) => InCompletedTaskDetailsScreen()),
          );
        }
        if (status.toUpperCase() == "COMPLETED") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CompletedTaskDetailsScreen()),
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
