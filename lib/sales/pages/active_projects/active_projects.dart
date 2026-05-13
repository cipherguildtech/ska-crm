import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../sales_service.dart';

class ActiveProjects extends StatefulWidget {
  const ActiveProjects({super.key});

  @override
  State<ActiveProjects> createState() => _ActiveProjectsState();
}

class _ActiveProjectsState extends State<ActiveProjects> {
  final SalesService salesService = SalesService();
  bool isLoading = true;
  List<dynamic> projects = [];
  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    projects = await salesService.fetchAllProjects();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Projects",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final date = DateTime.parse(project['deadline'].toString());
                final deadline =
                    '${DateFormat('MMMM').format(date)} ${date.day}, ${date.year}';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          _infoRow(
                            Icons.code,
                            "Project Code",
                            project['project_code'],
                          ),
                          _infoRow(
                            Icons.timelapse,
                            "Status",
                            project['status'],
                          ),
                          _infoRow(
                            Icons.description,
                            "Description",
                            project['description'],
                          ),

                          _infoRow(Icons.access_time, "Deadline", deadline),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),

          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$title : ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
