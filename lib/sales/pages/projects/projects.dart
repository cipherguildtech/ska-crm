import 'package:flutter/material.dart';
import 'package:ska_crm/sales/pages/projects/project_details.dart';

import '../../sales_service.dart';
import 'add_project.dart';

class Project {
  final String id;
  final String projectCode;
  final String title;
  final String subtitle;
  final DateTime deadline;
  final String status;

  Project({
    required this.projectCode,
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.status,
    required this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json["id"] ?? "",
      projectCode: json["project_code"] ?? "",
      title: json["customer"]?["name"] ?? "Unknown Customer",
      subtitle: json["description"] ?? "",
      deadline: DateTime.tryParse(json["deadline"] ?? "") ?? DateTime.now(),
      status: json["status"] ?? "PENDING",
    );
  }
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final SalesService salesService = SalesService();

  bool isLoading = true;

  List<Project> allProjects = [];
  List<Project> filteredProjects = [];

  String selectedFilter = "All";
  String searchQuery = "";
  bool sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      final response = await salesService.fetchAllProjects();

      allProjects = (response).map((e) => Project.fromJson(e)).toList();

      applyAll();
    } catch (e) {
      debugPrint("Error loading projects: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void applyAll() {
    List<Project> temp = [...allProjects];

    /// SEARCH
    if (searchQuery.isNotEmpty) {
      temp = temp.where((p) {
        return p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.projectCode.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    /// FILTER
    if (selectedFilter != "All") {
      temp = temp.where((p) {
        return p.status.toLowerCase() == selectedFilter.toLowerCase();
      }).toList();
    }

    /// SORT
    temp.sort(
      (a, b) => sortNewestFirst
          ? b.deadline.compareTo(a.deadline)
          : a.deadline.compareTo(b.deadline),
    );

    setState(() {
      filteredProjects = temp;
    });
  }

  String formatStatus(String status) {
    return status.replaceAll("_", " ");
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearch(),
                _buildFilters(),
                const SizedBox(height: 10),

                Expanded(
                  child: filteredProjects.isEmpty
                      ? const Center(child: Text("No projects found"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredProjects.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return SectionHeader(
                                onSort: () {
                                  setState(() {
                                    sortNewestFirst = !sortNewestFirst;
                                  });

                                  applyAll();
                                },
                              );
                            }

                            final p = filteredProjects[index - 1];

                            return ProjectCard(
                              id: p.id,
                              code: p.projectCode,
                              title: p.title,
                              subtitle: p.subtitle,
                              date:
                                  "${_monthName(p.deadline.month)} ${p.deadline.day}, ${p.deadline.year}",
                              status: formatStatus(p.status),
                            );
                          },
                        ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A8A8),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewCustomerProjectScreen()),
          );
        },
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          searchQuery = value;
          applyAll();
        },
        decoration: InputDecoration(
          hintText: "Search by ID or customer...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.filter_list),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip("All"),
            _filterChip("IN_PROGRESS"),
            _filterChip("COMPLETED"),
            _filterChip("PENDING"),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(formatStatus(label)),
        selected: selected,
        selectedColor: const Color(0xFF00A8A8).withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFF00A8A8) : Colors.grey,
        ),
        onSelected: (_) {
          selectedFilter = label;
          applyAll();
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final VoidCallback onSort;

  const SectionHeader({super.key, required this.onSort});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "RECENT PROJECTS",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onSort,
            child: const Text(
              "Sort by Date",
              style: TextStyle(
                color: Color(0xFF00A8A8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String code;
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;

  const ProjectCard({
    super.key,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toUpperCase() == "IN PROGRESS";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectDashboard(code: code)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00A8A8).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.layers_outlined, color: Colors.teal, size: 18),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 6),
                    Text(date),
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF00A8A8)
                              : Colors.grey,
                        ),
                        color: isActive
                            ? const Color(0xFF00A8A8).withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFF00A8A8)
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
