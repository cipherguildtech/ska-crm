import 'package:flutter/material.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';
import 'package:ska_crm/sales/pages/projects/project_details.dart';

import 'add_project.dart';

class Project {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final String status;

  Project({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
  });
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<Project> allProjects = [
    Project(
      id: "SKA-2025-0042",
      title: "Nexus Cloud Solutions",
      subtitle: "Infrastructure Upgrade",
      date: DateTime(2025, 10, 12),
      status: "Active",
    ),
    Project(
      id: "SKA-2025-0038",
      title: "Horizon Retail Group",
      subtitle: "E-commerce Integration",
      date: DateTime(2025, 9, 28),
      status: "Pending Approval",
    ),
    Project(
      id: "SKA-2025-0029",
      title: "GreenLeaf Organics",
      subtitle: "Sustainability Audit",
      date: DateTime(2025, 11, 5),
      status: "Active",
    ),
    Project(
      id: "SKA-2025-0021",
      title: "Urban Mobility Inc",
      subtitle: "Fleet Management System",
      date: DateTime(2025, 10, 30),
      status: "Active",
    ),
  ];

  List<Project> filteredProjects = [];

  String selectedFilter = "All";
  String searchQuery = "";
  bool sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    filteredProjects = [...allProjects];
    applyAll();
  }

  void applyAll() {
    List<Project> temp = [...allProjects];

    // 🔍 SEARCH
    if (searchQuery.isNotEmpty) {
      temp = temp.where((p) {
        return p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.id.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // 🎯 FILTER
    if (selectedFilter != "All") {
      temp = temp.where((p) => p.status == selectedFilter).toList();
    }

    // 📅 SORT
    temp.sort(
      (a, b) =>
          sortNewestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date),
    );

    setState(() {
      filteredProjects = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Column(
        children: [
          _buildSearch(),
          _buildFilters(),
          const SizedBox(height: 10),

          /// 📋 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredProjects.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SectionHeader(
                    onSort: () {
                      setState(() {
                        sortNewestFirst = !sortNewestFirst;
                        applyAll();
                      });
                    },
                  );
                }

                if (index == filteredProjects.length + 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "Load older projects",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final p = filteredProjects[index - 1];

                return ProjectCard(
                  id: p.id,
                  title: p.title,
                  subtitle: p.subtitle,
                  date:
                      "${_monthName(p.date.month)} ${p.date.day}, ${p.date.year}",
                  status: p.status,
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

  /// 🔍 SEARCH
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

  /// 🎯 FILTER
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _filterChip("All"),
          _filterChip("Active"),
          _filterChip("Pending Approval"),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: const Color(0xFF00A8A8).withOpacity(0.2),
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

  /// 📅 MONTH FORMAT
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
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;

  const ProjectCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == "Active";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectDashboard()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00A8A8).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Text(
                id,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.layers_outlined, color: primary),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: primary),
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
                            ? const Color(0xFF00A8A8).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
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
                    Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
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
