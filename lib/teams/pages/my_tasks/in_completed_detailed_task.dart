import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import './../../services/taskDetail.dart';

String? projectCode;
String? taskTitle;
DateTime? deadline;
String? department;
String? description;

class InCompletedTaskDetailsScreen extends StatefulWidget {
   String taskId;
   InCompletedTaskDetailsScreen({
     super.key,
     required this.taskId
   });
  @override
  State<InCompletedTaskDetailsScreen> createState() => _InCompletedTaskDetailsScreenState();
}


class _InCompletedTaskDetailsScreenState extends State<InCompletedTaskDetailsScreen> {

  Future<void> getTaskDetail() async {

  }



  final ImagePicker _picker = ImagePicker();
  List<File> images = [];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    if (projectCode == null || taskTitle == null || deadline == null || department == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
               projectCode!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              taskTitle!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if(deadline!.isBefore(DateTime.now())) Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "DELAYED",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ) ,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(deadline!.isBefore(DateTime.now()) && deadline != null) _deadlineMissedCard(),
            const SizedBox(height: 16),

            const Text(
              "Task Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _taskDescriptionCard(),

                  const SizedBox(height: 16),
                  _departmentRow(),

                  const SizedBox(height: 12),
                  _deadlineCard(),
                ],
              ),
            ),

            const SizedBox(height: 16),
            if(deadline!.isBefore(DateTime.now()))Column(
              children: [
                Row(
                  children: [
                    _sectionTitle("Reason for Delay"),
                    SizedBox(width: 5),
                    Text("*", style: TextStyle(color: Colors.red)),
                  ],
                ),
                _textField("Explain why the task is delayed..."),
                Text(
                  "Tip: Mention if you are waiting for materials or client approval.",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _sectionTitle("Work Details / Progress"),
            _textField("Enter current work progress..."),

            const SizedBox(height: 16),
            const Text(
              "Attachments",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            _attachmentsRow(),

            const SizedBox(height: 20),
            _startButton(),

            const SizedBox(height: 12),
            _completeButton(),
          ],
        ),
      ),
    );
  }

  Widget _deadlineMissedCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Deadline Missed",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Please provide a delay reason before completing.",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      width: 1000,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Task Description",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          SizedBox(height: 5),
           Text(
            description != null ? description! : 'no description'
          ),
        ],
      ),
    );
  }

  Widget _departmentRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.work, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          "DEPARTMENT\n${department!}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _deadlineCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              DateFormat('MMMM d,y . hh:mma').format(deadline!),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          if(deadline!.isBefore(DateTime.now())) Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "OVERDUE",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _textField(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _attachmentsRow() {
    return Column(
      children: [
        Row(
          children: [
            ...images.map(
              (img) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            images.remove(img);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _addBox(),
          ],
        ),
        Row(
          children: [
            Icon(Icons.image, color: Colors.grey),
            SizedBox(width: 5),
            Text("Supported: JPG, PNG(Max 8MB)"),
          ],
        ),
      ],
    );
  }

  Widget _addBox() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Icon(Icons.add)),
      ),
    );
  }

  Widget _startButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.play_circle_outline, color: Colors.teal),
        label: const Text(
          "Start Work",
          style: TextStyle(
            color: Colors.teal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.teal, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _completeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: const Text(
          "Mark as Completed",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
