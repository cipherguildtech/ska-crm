import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_user.dart';

class User {
  final String name;
  final String role;
  final String dept;
  final bool active;

  User({
    required this.name,
    required this.role,
    required this.dept,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['full_name'] ?? '',
      role: json['role'] ?? '',
      dept: json['department'] ?? 'N/A',
      active: json['is_active'] ?? false,
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
          'https://kz2nkt6c-3000.inc1.devtunnels.ms/users/basic_details',
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

    // SORT
    if (sortBy == "Name") {
      temp.sort((a, b) => a.name.compareTo(b.name));
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "User Management",
          style: TextStyle(
            color: Colors.black,
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
                      name: user.name,
                      role: user.role,
                      dept: user.dept,
                      active: user.active,
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
        PopupMenuButton<String>(
          onSelected: (value) {
            sortBy = value;
            applyLogic();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "Name",
              child: Text("Sort by Name"),
            ),
          ],
          child: Row(
            children: const [
              Text(
                "Sort By",
                style: TextStyle(color: Colors.teal),
              ),
              Icon(Icons.expand_more, color: Colors.teal),
            ],
          ),
        ),
      ],
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String role;
  final String dept;
  final bool active;

  const UserCard({
    super.key,
    required this.name,
    required this.role,
    required this.dept,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffE0F7F7),
                child: const Icon(
                  Icons.person,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    Text(
                      active ? "ACTIVE" : "INACTIVE",
                      style: TextStyle(
                        color: active
                            ? Colors.green
                            : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.edit_outlined),
            ],
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(Icons.shield, "ROLE", role),
              _infoItem(Icons.apartment, "DEPT.", dept),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xffE8F4F8),
          child: Icon(
            icon,
            size: 16,
            color: Colors.teal,
          ),
        ),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}