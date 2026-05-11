import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../review_task/review_task.dart';
import '../task_detail/task_detail.dart';
import '../assign_task/assign_task.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectCode;

  const ProjectDetailsPage({
    super.key,
    required this.projectCode,
  });

  @override
  State<ProjectDetailsPage> createState() =>
      _ProjectDetailsPageState();
}

class _ProjectDetailsPageState
    extends State<ProjectDetailsPage> {
  Map<String, dynamic>? projectData;

  bool isLoading = true;
  String selectedFilter = "ALL";

  @override
  void initState() {
    super.initState();
    fetchProjectDetails();
  }

  List get filteredTasks {
    final List tasks = projectData?['tasks'] ?? [];

    if (selectedFilter == "ALL") {
      return tasks;
    }

    return tasks.where((task) {
      return (task['status'] ?? "")
          .toString()
          .toUpperCase() ==
          selectedFilter;
    }).toList();
  }

  Future<void> fetchProjectDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://kz2nkt6c-3000.inc1.devtunnels.ms/projects/project_details/${widget.projectCode}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          projectData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildFilterChip(String label) {
    final isSelected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(
          label.replaceAll("_", " "),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        selectedColor: Colors.teal,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? Colors.teal
                : Colors.grey.shade300,
          ),
        ),
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
      ),
    );
  }

  String formatDate(String date) {
    return DateFormat(
      'MMM dd, yyyy',
    ).format(DateTime.parse(date));
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;

      case "IN_PROGRESS":
        return Colors.orange;

      case "CANCELLED":
        return Colors.red;

      case "REVIEW":
        return Colors.purple;

      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator( color: Colors.teal,),
        ),
      );
    }

    if (projectData == null) {
      return const Scaffold(
        body: Center(
          child: Text("No Data Found"),
        ),
      );
    }

    final tasks = projectData!['tasks'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,

        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "Project Detail",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              projectData!['project_code'],
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          final projectBasic = {
            "project_code": projectData!['project_code'],
            "service_type": projectData!['service_type'],
            "description": projectData!['description'],
            "status": projectData!['status'],
            "deadline": projectData!['deadline'],
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignTaskPage(
                project: projectBasic,
              ),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// PROJECT CARD
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color:
                      Colors.teal.withValues(alpha: 0.1),

                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [
                        Text(
                          "ID : ${projectData!['project_code']}",
                          style: const TextStyle(
                            color: Colors.teal,
                          ),
                        ),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),

                            border: Border.all(
                              color: Colors.teal,
                            ),
                          ),

                          child: Text(
                            projectData![
                            'service_type'],
                            style: const TextStyle(
                              color: Colors.teal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.all(14),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          projectData![
                          'description'],
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Status : ${projectData!['status']}",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [
                            const Text(
                              "SERVICE TYPE",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              projectData![
                              'service_type'],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .end,

                          children: [
                            const Text(
                              "DEADLINE",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              formatDate(
                                projectData![
                                'deadline'],
                              ),
                              style:
                              const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// TASK HEADER
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.layers,
                      color: Colors.teal,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "Task Details (${tasks.length})",
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildFilterChip("ALL"),
                  buildFilterChip("PENDING"),
                  buildFilterChip("IN_PROGRESS"),
                  buildFilterChip("COMPLETED"),
                  buildFilterChip("REVIEW"),
                  buildFilterChip("CANCELLED"),
                ],
              ),
            ),

            const SizedBox(height: 15),
            /// TASK LIST
            filteredTasks.isEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: const [
                    Icon(
                      Icons.inbox_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No tasks found",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredTasks.length,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),

              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return InkWell(
                    onTap: () {
                      final status = (task['status'] ?? "").toString();

                      if (status == "REVIEW") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(task: task),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommonTaskPage(task: task),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin:
                  const EdgeInsets.only(
                    bottom: 14,
                  ),

                  padding:
                  const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [
                          Text(
                            task['department'] ??
                                "",
                            style:
                            const TextStyle(
                              color:
                              Colors.grey,
                            ),
                          ),

                          Text(
                            task['status'],
                            style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                              color:
                              getStatusColor(
                                task['status'],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        task['title'] ?? "",
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        task['notes'] ?? "",
                        style:
                        const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const Divider(height: 20),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            formatDate(
                              task['due_at'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}