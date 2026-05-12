import 'package:flutter/material.dart';
import '../../../hr/services/teams.dart';
import '../../../hr/teams/details/user_details.dart';
import '../../../hr/teams/widgets/staff_card.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  bool isLoading = true;

  bool sortHighToLow = true;

  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        backgroundColor: isError ? Colors.red : Colors.teal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  Future<void> fetchTeams() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await TeamService.fetchTeams();

      setState(() {
        teams = response;
        teams.sort(
              (a, b) => sortHighToLow
              ? b['tasks'].compareTo(a['tasks'])
              : a['tasks'].compareTo(b['tasks']),
        );

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      _showMessage("Error: $e", isError: true);
    }
  }

  void sortTeams(bool highToLow) {
    setState(() {
      sortHighToLow = highToLow;
      teams.sort(
            (a, b) => sortHighToLow
            ? b['tasks'].compareTo(a['tasks'])
            : a['tasks'].compareTo(b['tasks']),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Teams Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
          body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search by name or department",
                    hintStyle: TextStyle(
                      color: Colors.teal.withValues(alpha: 0.6),
                    ),
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
                child: Column(
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
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.teal,
                          ),
                          onSelected: (value) {
                            if (value == 'high_to_low') {
                              sortTeams(true);
                            } else {
                              sortTeams(false);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'high_to_low',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.teal,
                                  ),
                                  SizedBox(width: 8),
                                  Text("High → Low Tasks"),
                                ],
                              ),
                            ),

                            const PopupMenuItem(
                              value: 'low_to_high',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    color: Colors.teal,
                                  ),
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

                    if (teams.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No team members found"),
                        ),
                      )
                    else
                      Column(
                        children: teams.map((member) {
                          return StaffCard(
                            name: member['name'],
                            role:
                            "${member['department']} ${member['role']}",
                            tasks: member['tasks'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Detail(phone: member['phone']),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                  ],
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
