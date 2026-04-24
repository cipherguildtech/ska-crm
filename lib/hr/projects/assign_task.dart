import 'package:flutter/material.dart';

class AssignTaskPage extends StatelessWidget {
  const AssignTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Assign Task",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.help_outline, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _projectCard(),
            const SizedBox(height: 20),

            _label("Task Title *"),
            _inputField("Prepare campaign brief"),

            const SizedBox(height: 16),

            _label("Description"),
            _inputField(
              "Describe the specific deliverables and context...",
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            _label("Assign To *"),
            _searchField(),

            const SizedBox(height: 12),

            _memberTile(
              name: "Priya Sharma",
              role: "Marketing Lead",
              tasks: "1 Task",
              selected: true,
              recommended: true,
            ),
            _memberTile(
              name: "Rahul Gupta",
              role: "Senior Designer",
              tasks: "3 Tasks",
            ),
            _memberTile(
              name: "Anika Roy",
              role: "Copywriter",
              tasks: "5 Tasks",
            ),

            const SizedBox(height: 16),

            _label("Due Date *"),
            Row(
              children: [
                _chip("Today"),
                _chip("In 3 Days"),
                _chip("1 Week"),
              ],
            ),

            const SizedBox(height: 12),

            _datePicker(),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "SAVE AS DRAFT",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            _assignButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ---------------- //

  Widget _projectCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("PROJECT ID", style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Text("PRJ-2026-042", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            "Summer Launch Campaign",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text("Client: Global Systems Inc"),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Digital Marketing"),
              Text(
                "Apr 30, 2026",
                style: TextStyle(color: Colors.red),
              ),
            ],
          )
        ],
      ),
    );
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

  Widget _inputField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search team members...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _memberTile({
    required String name,
    required String role,
    required String tasks,
    bool selected = false,
    bool recommended = false,
  }) {
    return Container(
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
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    if (recommended)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("Recommended",
                            style: TextStyle(fontSize: 10)),
                      )
                  ],
                ),
                Text(role, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(tasks, style: const TextStyle(fontSize: 12)),
              ),
              if (selected)
                const Icon(Icons.check, color: Colors.teal)
            ],
          )
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  Widget _datePicker() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.calendar_today, size: 18),
          SizedBox(width: 10),
          Text("Apr 14, 2026"),
        ],
      ),
    );
  }

  Widget _assignButton() {
    return Container(
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
    );
  }
}