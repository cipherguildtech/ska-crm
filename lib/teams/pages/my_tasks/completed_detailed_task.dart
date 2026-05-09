import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/taskDetail.dart';
class CompletedTaskDetailsScreen extends StatefulWidget {
  String taskId;


  CompletedTaskDetailsScreen(
      {
        super.key,
        required this.taskId
      }
      );
  @override
  State<CompletedTaskDetailsScreen> createState() => _CompletedTaskDetailsScreenState();
}



class _CompletedTaskDetailsScreenState extends State<CompletedTaskDetailsScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final taskDetailService = TaskDetailService();
  String? projectCode;
  String? taskTitle;
  DateTime? deadline;
  String? department;
  String? description;
  String? workDetails;
  String? files;
  Future<void> getTaskDetail() async {
    Map<dynamic, dynamic>? completedTaskDetail = await taskDetailService.fetchTask(widget.taskId);
    print(completedTaskDetail);
    if(completedTaskDetail != null){
      setState(() {
        projectCode = completedTaskDetail['project']['project_code'];
        taskTitle = completedTaskDetail['title'];
        deadline = DateTime.parse(completedTaskDetail['due_at']);
        department = completedTaskDetail['department'];
        description = completedTaskDetail['description'];
        workDetails = completedTaskDetail['work_details'];
        files = completedTaskDetail['files'];
      });
    }
    else {

    }

  }

  @override
  void initState() {
    super.initState();
    getTaskDetail();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        setState(() {
          getTaskDetail();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (projectCode == null || taskTitle == null || deadline == null || department == null ) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectCode!,
              style: const TextStyle(fontSize: 12, color: Colors.teal),
            ),
            const SizedBox(height: 2),
            Text(
              taskTitle!,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Task Description Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDDEFF1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Task Description",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                   Text(
                    description ?? 'no description',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Department + Deadline Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE8F1FF),
                        child: Icon(Icons.work, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DEPARTMENT",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            department!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFE0F7F6),
                          child: Icon(Icons.calendar_today, color: Colors.teal),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "DEADLINE",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d,y . hh:mma').format(deadline!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Work Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child:  Text(
                 workDetails ?? 'no work details',
                style: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Attachments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // Image attachment
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://picsum.photos/200",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                // File attachment
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.insert_drive_file,
                    color: Colors.grey,
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
