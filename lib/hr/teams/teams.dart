import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'staff_details/staff_details.dart';


class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  late Future<List<TeamMember>> futureTeams;
  bool sortHighToLow = true;

  @override
  void initState() {
    super.initState();
    futureTeams = fetchTeams();
  }

  Future<List<TeamMember>> fetchTeams() async {
    final response = await http.get(
      Uri.parse("https://kz2nkt6c-3000.inc1.devtunnels.ms/users/tasks"),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => TeamMember.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load teams");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Teams Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name or department",
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

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<TeamMember>>(
                  future: futureTeams,
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No team members found"));
                    }
                    final teams = List<TeamMember>.from(snapshot.data!);

                    teams.sort((a, b) => sortHighToLow
                        ? b.tasks.compareTo(a.tasks)
                        : a.tasks.compareTo(b.tasks));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ALL STAFFS (${teams.length})",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.filter_list, color: Colors.teal),
                              onSelected: (value) {
                                setState(() {
                                  if (value == 'high_to_low') {
                                    sortHighToLow = true;
                                  } else if (value == 'low_to_high') {
                                    sortHighToLow = false;
                                  }
                                });
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'high_to_low',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.arrow_downward, color: Colors.teal),
                                      SizedBox(width: 8),
                                      Text("High → Low Tasks"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'low_to_high',
                                  child: Row(
                                    children: const [
                                      Icon(Icons.arrow_upward, color: Colors.teal),
                                      SizedBox(width: 8),
                                      Text("Low → High Tasks"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Column(
                          children: teams.map((member) {
                            return StaffCard(
                              name: member.name,
                              role: "${member.department ?? ''} ${member.role} ",
                              tasks: member.tasks,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StaffDetail(phone: member.phone),                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String? department;
  final int tasks;
  final String phone; // ✅ ADD THIS

  TeamMember({
    required this.name,
    required this.role,
    required this.department,
    required this.tasks,
    required this.phone,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json['full_name'],
      role: json['role'],
      department: json['department'],
      tasks: json['_count']?['assigned_tasks'] ?? 0,
      phone: json['phone'] ?? "N/A", // ✅ SAFE PARSING
    );
  }
}

class StaffCard extends StatelessWidget {
  final String name;
  final String role;
  final int tasks;
  final VoidCallback? onTap;

  const StaffCard({
    super.key,
    required this.name,
    required this.role,
    required this.tasks,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
        color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side:  BorderSide(
        color: Colors.teal.withValues(alpha: 0.1),
        width: 1,
      ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: ListTile(
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role),
              const SizedBox(height: 4),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$tasks Tasks",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}