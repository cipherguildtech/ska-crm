import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ska_crm/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignTaskPage extends StatefulWidget {
  final Map<String, dynamic> project;

  const AssignTaskPage({super.key, required this.project});

  @override
  State<AssignTaskPage> createState() => _AssignTaskPageState();
}
class _AssignTaskPageState extends State<AssignTaskPage> {
  bool isLoading = true;
  String? selectedUserPhone;
  String? selectedUserId;
  String? selectedUserDepartment;
  bool isQuotation = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<dynamic> users = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  Color getTaskColor(int taskCount) {
    if (taskCount >= 5) return Colors.red;
    if (taskCount >= 3) return Colors.orange;
    return Colors.green;
  }
  DateTime? selectedDate;
  List<dynamic> get filteredUsers {
    if (searchQuery.isEmpty) return users;

    return users.where((user) {
      final name = (user['full_name'] ?? '').toString().toLowerCase();
      final role = (user['role'] ?? '').toString().toLowerCase();
      final dept = (user['department'] ?? '').toString().toLowerCase();

      return name.contains(searchQuery) ||
          role.contains(searchQuery) ||
          dept.contains(searchQuery);
    }).toList();
  }
  int getPriorityScore(dynamic user) {
    final tasks = user['_count']?['assigned_tasks'] ?? 0;

    if (tasks == 0) return 3;      // HIGH priority (free users)
    if (tasks < 3) return 2;       // MEDIUM
    return 1;                      // LOW (busy users)
  }
@override
void initState() {
  super.initState();
  fetchUsers();
}

Future<void> fetchUsers() async {
  try {
    final res = await http.get(
      Uri.parse("$baseUrl/users/tasks"),
    );

    if (res.statusCode == 200) {
      setState(() {
        users = jsonDecode(res.body);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load users");
    }
  } catch (e) {
    setState(() => isLoading = false);
    debugPrint(e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        title: const Text(
          "Assign Task",
          style: TextStyle( fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          "ID : ${widget.project['project_code']}",
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
                            widget.project[
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
                          widget.project[
                          'description'],
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Status : ${widget.project['status']}",
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
                              widget.project[
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
                                widget.project[
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

            _label("Task Title *"),
            _inputField(
              "Prepare campaign brief",
              controller: titleController,
            ),
            const SizedBox(height: 16),

            _label("Description"),
            _inputField(
              "Describe the specific deliverables and context...",
              controller: descriptionController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            _label("Additional Notes"),
            _inputField(
              "Enter additional notes...",
              controller: notesController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mark as Quotation Task",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: isQuotation,
                    activeThumbColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        isQuotation = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _label("Assign To *"),
            _searchField(),

            const SizedBox(height: 12),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: (() {
                final sortedUsers = [...filteredUsers];

                sortedUsers.sort((a, b) {
                  return getPriorityScore(b).compareTo(getPriorityScore(a));
                });

                return sortedUsers.map((user) {
                  final tasks =
                      user['_count']?['assigned_tasks'] ?? 0;

                  final taskColor = getTaskColor(tasks);

                  return _memberTile(
                    name: user['full_name'] ?? '',
                    role:
                    "${user['department'] ?? ''}  ${user['role'] ?? ''}",
                    tasks: tasks.toString(),
                    taskColor: taskColor,
                    selected: selectedUserId == user['id'],

                    onTap: () {
                      setState(() {
                        selectedUserId = user['id'];
                        selectedUserPhone = user['phone']; // ADD THIS
                        selectedUserDepartment = user['department']; // ✅ ADD THIS
                      });
                    },
                  );
                }).toList();
              })(),
            ),

            const SizedBox(height: 16),

            _label("Due Date *"),

            const SizedBox(height: 12),

            _datePicker(),

            const SizedBox(height: 30),

            _assignButton(),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
  String formatDate(String? date) {
    if (date == null) return "-";
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(date));
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _inputField(String hint,
      {int maxLines = 1, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: Colors.teal,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.teal.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.teal,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value.toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: "Search by name, role, department...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.teal.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.teal),
        ),
      ),
    );
  }

  Widget _memberTile({
    required String name,
    required String role,
    required String tasks,
    required Color taskColor,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.teal[50] : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.teal : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
             CircleAvatar(
              backgroundColor: Colors.teal.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    role,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: taskColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$tasks Tasks",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: taskColor,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.check, color: Colors.teal),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(), // 🚫 prevents past dates
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.teal),
            const SizedBox(width: 10),
            Text(
              selectedDate == null
                  ? "Select Due Date"
                  : DateFormat('MMM dd, yyyy').format(selectedDate!),
              style: TextStyle(
                color: selectedDate == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> assignTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString("phone"); // assigned_by phone

      final requestBody = {
        "project_code": widget.project['project_code'],
        "is_quotation": isQuotation,
        "assigned_to_phone": selectedUserPhone,
        "assigned_by_phone": phone,
        "department": selectedUserDepartment!.toUpperCase(),
        "title": titleController.text,
        "description": descriptionController.text,
        "notes": notesController.text,
        "due_at": selectedDate?.toIso8601String(),
        "status": "PENDING",
      };

      final res = await http.post(
        Uri.parse("$baseUrl/tasks/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (!mounted) return;

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showMessage("Task Assigned Successfully");

        Navigator.pop(context);
      }else {
        throw Exception(res.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _assignButton() {
    return GestureDetector(
      onTap: assignTask,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.green],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Assign Task",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}