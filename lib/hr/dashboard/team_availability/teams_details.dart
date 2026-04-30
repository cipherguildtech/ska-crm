import 'package:flutter/material.dart';
import '../../services/dashboard.dart';
import 'widget/team_card.dart';

const Color primary = Color(0xFF1BA39C);

class TeamDetailsPage extends StatefulWidget {
  const TeamDetailsPage({super.key});

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  List teams = [];
  List filteredTeams = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();
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
        filteredTeams = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      _showMessage("Failed to load teams");

    }
  }

  void filterTeams(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTeams = teams;
      });
    } else {
      setState(() {
        filteredTeams = teams.where((team) {
          final name = (team['name'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Team Details"),
        backgroundColor: const Color(0xFF1BA39C),
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      )
          : Column(
          children: [
      Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: filterTeams,
        cursorColor: Colors.teal,
        decoration: InputDecoration(
          hintText: "Search by team name...",
          hintStyle: TextStyle(color: Colors.teal.withValues(alpha: 0.6)),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.teal,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.teal,
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.teal,
              width: 1,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),

    Expanded(
    child: filteredTeams.isEmpty
    ? const Center(
    child: Text("No team data available"),
    )
        : ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: filteredTeams.length,
    itemBuilder: (context, index) {

      final team = filteredTeams[index] as Map<String, dynamic>;

      return TeamCard(team: team);
      },
      ),
    ),
    ],
      ),
    );
  }
}