import 'package:flutter/material.dart';

import 'add_user.dart';

class User {
  final String name;
  final String role;
  final String dept;
  final int tasks;
  final bool active;

  User({
    required this.name,
    required this.role,
    required this.dept,
    required this.tasks,
    required this.active,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [
    User(
      name: "Sarah Jenkins",
      role: "Admin",
      dept: "Engineering",
      tasks: 12,
      active: true,
    ),
    User(
      name: "Marcus Thorne",
      role: "Sales",
      dept: "Enterprise",
      tasks: 5,
      active: true,
    ),
    User(
      name: "Elena Rodriguez",
      role: "HR",
      dept: "People & Ops",
      tasks: 0,
      active: false,
    ),
  ];

  List<User> filteredUsers = [];

  String searchQuery = "";
  String selectedFilter = "All";
  String sortBy = "Name";

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  void applyLogic() {
    List<User> temp = [...users];

    // 🔍 SEARCH
    if (searchQuery.isNotEmpty) {
      temp = temp.where((user) {
        return user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user.role.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user.dept.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // 🎯 FILTER
    if (selectedFilter == "Active") {
      temp = temp.where((u) => u.active).toList();
    } else if (selectedFilter == "Inactive") {
      temp = temp.where((u) => !u.active).toList();
    }

    // 🔃 SORT
    if (sortBy == "Name") {
      temp.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy == "Tasks") {
      temp.sort((a, b) => b.tasks.compareTo(a.tasks));
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
          );
        },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "User Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
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
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return UserCard(
                    name: user.name,
                    role: user.role,
                    dept: user.dept,
                    tasks: user.tasks,
                    active: user.active,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔍 SEARCH BAR
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

  // 🎯 FILTERS
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

  // 🔃 SORT
  Widget _headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ALL USERS (${filteredUsers.length})",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            sortBy = value;
            applyLogic();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: "Name", child: Text("Sort by Name")),
            PopupMenuItem(value: "Tasks", child: Text("Sort by Tasks")),
          ],
          child: Row(
            children: const [
              Text("Sort By", style: TextStyle(color: Colors.teal)),
              Icon(Icons.expand_more, color: Colors.teal),
            ],
          ),
        ),
      ],
    );
  }
}

// 🧩 USER CARD
class UserCard extends StatelessWidget {
  final String name;
  final String role;
  final String dept;
  final int tasks;
  final bool active;

  const UserCard({
    super.key,
    required this.name,
    required this.role,
    required this.dept,
    required this.tasks,
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
                child: const Icon(Icons.person, color: Colors.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: active ? Colors.green : Colors.grey,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(Icons.shield, "ROLE", role),
              _infoItem(Icons.apartment, "DEPT.", dept),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 6),
                  Text("$tasks Active Tasks"),
                ],
              ),
              Row(
                children: [
                  Text(active ? "Deactivate" : "Activate"),
                  Switch(
                    value: active,
                    onChanged: (_) {},
                    activeColor: Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xffE8F4F8),
          child: Icon(icon, size: 16, color: Colors.teal),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 10)),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
