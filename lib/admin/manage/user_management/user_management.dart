import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';
import 'add_user.dart';

class User {
  final String name;
  final String role;
  final String dept;
  final bool active;
  final String phone;
  final String email;

  User({
    required this.name,
    required this.role,
    required this.dept,
    required this.active,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['full_name'] ?? '',
      role: json['role'] ?? '',
      dept: json['department'] ?? 'N/A',
      active: json['is_active'] ?? false,
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<User> users = [];
  List<User> filteredUsers = [];

  String searchQuery = "";
  String selectedFilter = "All";
  String sortBy = "Name";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();


    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return false;

      fetchUsers(showLoader: false);
      return true;
    });
  }

  Future<void> fetchUsers({bool showLoader = true}) async {
    try {
      if (showLoader) {
        setState(() => isLoading = true);
      }

      final response = await http.get(
        Uri.parse(
          '$baseUrl/users/basic_details',
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        users = data.map((e) => User.fromJson(e)).toList();

        applyLogic();
      } else {
        debugPrint("Failed to load users");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void applyLogic() {
    List<User> temp = [...users];

    // SEARCH
    if (searchQuery.isNotEmpty) {
      temp = temp.where((user) {
        return user.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        ) ||
            user.role.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            user.dept.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // FILTER
    if (selectedFilter == "Active") {
      temp = temp.where((u) => u.active).toList();
    } else if (selectedFilter == "Inactive") {
      temp = temp.where((u) => !u.active).toList();
    }

    setState(() {
      filteredUsers = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F9),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1FA2A6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUserScreen()),
          ).then((_) {
            fetchUsers();
          });
        },
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "User Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 16),
            _filters(),
            const SizedBox(height: 16),
            _headerRow(),
            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : RefreshIndicator(
                onRefresh: fetchUsers,
                child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

                  return UserCard(
                    key: ValueKey(user.phone),
                    name: user.name,
                    role: user.role,
                    dept: user.dept,
                    active: user.active,
                    phone: user.phone,
                    email: user.email,
                  );
                  },
              ),
            ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      onChanged: (value) {
        searchQuery = value;
        applyLogic();
      },
      decoration: InputDecoration(
        hintText: "Search by name, role, department...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _filters() {
    return Row(
      children: [
        _filterChip("All"),
        _filterChip("Active"),
        _filterChip("Inactive"),
      ],
    );
  }

  Widget _filterChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: selectedFilter == text,
        onSelected: (_) {
          selectedFilter = text;
          applyLogic();
        },
        selectedColor: const Color(0xffD6F2F3),
      ),
    );
  }

  Widget _headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ALL USERS (${filteredUsers.length})",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class UserCard extends StatefulWidget {
  final String name;
  final String role;
  final String dept;
  final bool active;
  final String phone;
  final String email;

  const UserCard({
    super.key,
    required this.name,
    required this.role,
    required this.dept,
    required this.active,
    required this.phone,
    required this.email,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late bool isActive;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.active;
  }
  void showMessage(String message, {bool isError = false}) {
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

  Future<void> updateUserStatus(bool value) async {
    try {
      final response = await http.put(
        Uri.parse(
          "$baseUrl/users/user/${widget.phone}/activate_or_deactivate/$value",
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        if (!mounted) return;
        showMessage( value
            ? "User Activated"
            : "User Deactivated");
      }
    } catch (e) {

      setState(() {
        isActive = !value;
      });

      showMessage("Error: $e");

    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP
          Row(
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.teal,
                child: Text(
                  widget.name.isNotEmpty
                      ? widget.name[0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (widget.dept.trim().isNotEmpty ||
                        widget.role.trim().isNotEmpty)
                      Text(
                        [
                          if (widget.dept.trim().isNotEmpty &&
                              widget.dept.toLowerCase() != "n/a")
                            widget.dept.replaceAll("_", " "),

                          if (widget.role.trim().isNotEmpty)
                            widget.role,
                        ].join(" "),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddUserScreen(
                        isEdit: true,
                        phone: widget.phone,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.teal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// DETAILS BOX
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FA),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Column(
              children: [

                _detailRow(
                  Icons.email_outlined,
                  "Email",
                  widget.email,
                ),

                const SizedBox(height: 12),

                _detailRow(
                  Icons.phone_outlined,
                  "Phone",
                  widget.phone,
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Icon(
                      isActive
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 20,
                      color: isActive
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      isActive
                          ? "Active"
                          : "Inactive",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),

                    const Spacer(),

                    isUpdating
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Switch(
                      value: isActive,
                      activeThumbColor: Colors.teal,
                      onChanged: (value) async {

                        setState(() {
                          isActive = value;
                          isUpdating = true;
                        });

                        await updateUserStatus(value);

                        if (mounted) {
                          setState(() {
                            isUpdating = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Icon(
          icon,
          size: 20,
          color: Colors.teal,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}