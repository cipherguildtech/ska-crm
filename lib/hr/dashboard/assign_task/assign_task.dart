import 'package:flutter/material.dart';

class AssignTaskPage extends StatefulWidget {
  final String projectId;

  const AssignTaskPage({super.key, required this.projectId});

  @override
  State<AssignTaskPage> createState() => _AssignTaskPageState();
}

class _AssignTaskPageState extends State<AssignTaskPage> {
  int selectedUserIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Assign Task"),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _projectCard(),
            const SizedBox(height: 20),
            _textField("Task Title *", "Prepare campaign brief"),
            const SizedBox(height: 16),
            _descriptionField(),
            const SizedBox(height: 16),
            _assignSection(),
            const SizedBox(height: 20),
            _dueDateSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _projectCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("PROJECT ID",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Planning",
                    style: TextStyle(color: Colors.teal)),
              )
            ],
          ),
          const SizedBox(height: 4),
          const Text("PRJ-2026-042",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Summer Launch Campaign",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Client: Global Systems Inc"),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SERVICE TYPE",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("Digital Marketing"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("DEADLINE",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("Apr 30, 2026",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _textField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        )
      ],
    );
  }

  Widget _descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Description"),
        const SizedBox(height: 6),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText:
            "Describe the specific deliverables and context for the team member...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        )
      ],
    );
  }

  Widget _assignSection() {
    final users = [
      {"name": "Priya Sharma", "role": "Marketing Lead", "tasks": "1 Task"},
      {"name": "Rahul Gupta", "role": "Senior Designer", "tasks": "3 Tasks"},
      {"name": "Anika Roy", "role": "Copywriter", "tasks": "5 Tasks"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Assign To *"),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Search team members...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(users.length, (index) {
          final user = users[index];
          final isSelected = selectedUserIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => selectedUserIndex = index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.teal.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected ? Colors.teal : Colors.transparent),
              ),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user["name"]!,
                            style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                        Text(user["role"]!,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(user["tasks"]!),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, color: Colors.teal),
                    )
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
        const Text(
          "Sorted by least busy by default. Tap to select.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        )
      ],
    );
  }

  Widget _dueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Due Date *"),
        const SizedBox(height: 10),
        Row(
          children: [
            _chip("Today"),
            _chip("In 3 Days"),
            _chip("1 Week"),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(),
          child: const Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 10),
              Text("Apr 14, 2026"),
            ],
          ),
        )
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(text)),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("SAVE AS DRAFT",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text("Assign Task"),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}