import 'package:flutter/material.dart';
import '../../services/dashboard.dart';

const Color primary = Color(0xFF1BA39C);

class TeamDetailsPage extends StatefulWidget {
  const TeamDetailsPage({super.key});

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  List teams = []; // ✅ FIXED
  bool isLoading = true;

  final DashboardService _dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    setState(() => isLoading = true);

    try {
      final data = await _dashboardService.fetchTeams();

      setState(() {
        teams = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      _showMessage("Failed to load teams");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Details"),
        backgroundColor: const Color(0xFF1BA39C),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : teams.isEmpty
          ? const Center(child: Text("No team data available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teams.length,
        itemBuilder: (context, index) {

          final team = teams[index] as Map<String, dynamic>; // ✅ SAFE CAST

          /// 🔹 Extract users (dynamic keys)
          final List users = team['users'] ?? [];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Department Header
                Row(
                  children: [
                    const Icon(Icons.groups,
                        color: Color(0xFF1BA39C)),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        team['name'] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Text(
                      "${team['tasks'] ?? 0} Tasks",
                      style:
                      const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                /// 🔹 USERS LIST
                if (users.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Divider(),

                  Column(
                    children: users.map<Widget>((user) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(user['name'] ?? ""),
                            ),

                            Text(
                              "${user['count'] ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}