import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'project_detail/projectdetails.dart';
import '../services/project.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  List<dynamic> allProjects = [];
  List<dynamic> filteredProjects = [];

  bool isLoading = true;
  String selectedFilter = "All";

  final List<String> projectStatuses = [
    "All",
    "ACTIVE",
    "ON_HOLD",
    "PENDING",
    "IN_PROGRESS",
    "COMPLETED",
    "CANCELLED",
  ];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      final data = await ProjectService.fetchProjects();

      setState(() {
        allProjects = data;
        filteredProjects = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProjects(String query) {
    final result = allProjects.where((project) {
      final code = (project['project_code'] ?? '')
          .toString()
          .toLowerCase();

      final customer = (project['customer']?['name'] ?? '')
          .toString()
          .toLowerCase();

      return code.contains(query.toLowerCase()) ||
          customer.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProjects = result;
    });
  }

  void filterByStatus(String filter) {
    setState(() {
      selectedFilter = filter;

      if (filter == "All") {
        filteredProjects = allProjects;
      } else {
        filteredProjects = allProjects.where((project) {
          return project['status']
              .toString()
              .toLowerCase()
              .contains(filter.toLowerCase());
        }).toList();
      }
    });
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(date));
  }

  bool isOverdue(String deadline) {
    return DateTime.parse(deadline).isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      "All Projects",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterProjects,
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Search by ID or customer...",
                      prefixIcon: const Icon(Icons.search),

                      filled: true,
                      fillColor: Colors.white,

                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ),

                      // DEFAULT BORDER
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),

                      // ENABLED BORDER
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),

                      // FOCUSED BORDER
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.teal,
                          width: 1.5,
                        ),
                      ),

                      // ERROR BORDER
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // FOCUSED ERROR BORDER
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // FILTER CHIPS
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: projectStatuses.length,
                    itemBuilder: (context, index) {
                      return buildChip(projectStatuses[index]);
                    },
                  ),
                ),

                const SizedBox(height: 22),

                // HEADER
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ALL PROJECTS (${filteredProjects.length})",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // PROJECT LIST
                isLoading
                    ? const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                )
                    : filteredProjects.isEmpty
                    ? const Padding(
                  padding:
                  EdgeInsets.only(top: 80),
                  child: Center(
                    child: Text(
                      "No Projects Found",
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount:
                  filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project =
                    filteredProjects[index];

                    return ProjectCard(
                      id: (project['project_code'] ?? '-').toString(),
                      title: project['customer']?['name']?.toString() ?? 'No Customer',
                      subtitle: project['description']?.toString() ?? 'No Description',
                      date: formatDate(project['deadline']?.toString()),
                      projectCode: (project['project_code'] ?? '').toString(),
                      status: (project['status'] ?? 'UNKNOWN').toString(),
                      serviceType: (project['service_type'] ?? 'GENERAL').toString(),
                      isOverdue: isOverdue(project['deadline']?.toString() ?? ''),
                      projectData: project,
                    );
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChip(String label) {
    final isSelected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: ChoiceChip(
          showCheckmark: false,

          label: Text(
            label.replaceAll("_", " "),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Colors.grey.shade700,
            ),
          ),

          selected: isSelected,

          backgroundColor: Colors.white,

          selectedColor: Colors.teal,

          elevation: isSelected ? 2 : 0,

          pressElevation: 0,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isSelected
                  ? Colors.teal
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),

          onSelected: (_) {
            filterByStatus(label);
          },
        ),
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
  final String serviceType;
  final bool isOverdue;
  final dynamic projectData;
  final String projectCode;
  const ProjectCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.serviceType,
    required this.projectData,
    required this.projectCode,
    this.isOverdue = false,
  });

  Color getStatusColor() {
    switch (status) {
      case "ACTIVE":
        return Colors.blue;

      case "ON_HOLD":
        return Colors.amber;

      case "PENDING":
        return Colors.grey;

      case "IN_PROGRESS":
        return Colors.orange;

      case "COMPLETED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.teal;
    }
  }

  Color getServiceColor() {
    switch (serviceType) {
      case "LED_BOARD":
        return Colors.deepPurple;

      case "BRANDING":
        return Colors.teal;

      case "BANNER":
        return Colors.orange;

      case "DESIGN":
        return Colors.pink;

      case "ROAD_SHOW":
        return Colors.indigo;

      case "PAMPLET":
        return Colors.cyan;

      case "VISITING_CARD":
        return Colors.brown;

      default:
        return Colors.blueGrey;
    }
  }

  IconData getServiceIcon() {
    switch (serviceType) {
      case "LED_BOARD":
        return Icons.lightbulb_outline;

      case "BRANDING":
        return Icons.branding_watermark_outlined;

      case "BANNER":
        return Icons.flag_outlined;

      case "DESIGN":
        return Icons.design_services_outlined;

      case "ROAD_SHOW":
        return Icons.directions_car_outlined;

      case "PAMPLET":
        return Icons.menu_book_outlined;

      case "VISITING_CARD":
        return Icons.badge_outlined;

      default:
        return Icons.work_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectCode: projectCode,
            ),
          ),
        );
      },      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: getServiceColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    getServiceIcon(),
                    color: getServiceColor(),
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        id,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                    getStatusColor().withValues(alpha: 0.1),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Text(
                    status.replaceAll("_", " "),
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 18),

            /// DESCRIPTION
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 18),

            /// DIVIDER
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),

            const SizedBox(height: 14),

            /// BOTTOM ROW
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                    getServiceColor().withValues(alpha: 0.1),
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        getServiceIcon(),
                        size: 16,
                        color: getServiceColor(),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        serviceType
                            .replaceAll("_", " "),
                        style: TextStyle(
                          color: getServiceColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: isOverdue
                      ? Colors.red
                      : Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  date,
                  style: TextStyle(
                    color: isOverdue
                        ? Colors.red
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
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