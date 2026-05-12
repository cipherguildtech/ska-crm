import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String phoneNumber;

  const CustomerDetailsPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<CustomerDetailsPage> createState() =>
      _CustomerDetailsPageState();
}

class _CustomerDetailsPageState
    extends State<CustomerDetailsPage> {

  bool isLoading = true;

  Map<String, dynamic>? customerData;

  List projects = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
  }

  Future<void> fetchCustomerDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          "$baseUrl/customers/projects/${widget.phoneNumber}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        customerData = data;

        projects = data['projects'] ?? [];

        setState(() {});
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);

      return "${parsed.day}-${parsed.month}-${parsed.year}";
    } catch (e) {
      return date;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return Colors.teal;

      case "IN_PROGRESS":
        return Colors.orange;

      case "COMPLETED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          "Customer Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : customerData == null
          ? const Center(
        child: Text(
          "Customer not found",
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            /// CUSTOMER CARD
            CustomerCard(
              customerData: customerData!,
            ),

            const SizedBox(height: 22),

            /// PROJECT HEADER
            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [

                Text(
                  "Projects (${projects.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// PROJECT LIST
            if (projects.isEmpty)
              Container(
                padding:
                const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "No projects available",
                  ),
                ),
              ),

            ...projects.map(
                  (project) => ProjectCard(
                id:
                project['project_code'] ??
                    '',
                title:
                project['description'] ??
                    '',
                deadline: formatDate(
                  project['deadline'] ?? '',
                ),
                status:
                project['status'] ?? '',
                serviceType:
                project['service_type'] ??
                    '',
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "END OF RECORDS",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customerData;

  const CustomerCard({
    super.key,
    required this.customerData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade700,
          ],
        ),

        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          /// AVATAR
          CircleAvatar(
            radius: 32,
            backgroundColor:
            Colors.white.withOpacity(0.15),

            child: Text(
              customerData['name'][0]
                  .toString()
                  .toUpperCase(),

              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  customerData['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  customerData['customer_type'] ??
                      '',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 14),

                infoRow(
                  Icons.phone,
                  customerData['phone'] ?? '',
                ),

                const SizedBox(height: 8),

                infoRow(
                  Icons.email,
                  customerData['email'] ?? '',
                ),

                const SizedBox(height: 8),

                infoRow(
                  Icons.location_on,
                  customerData['address'] ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(
      IconData icon,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String id;
  final String title;
  final String deadline;
  final String status;
  final String serviceType;

  const ProjectCard({
    super.key,
    required this.id,
    required this.title,
    required this.deadline,
    required this.status,
    required this.serviceType,
  });

  Color getStatusColor() {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return Colors.teal;

      case "IN_PROGRESS":
        return Colors.orange;

      case "COMPLETED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.grey;
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
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          /// TOP
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [

              Expanded(
                child: Text(
                  id,
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: getStatusColor()
                      .withOpacity(0.12),

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                ),

                child: Text(
                  status.replaceAll("_", " "),

                  style: TextStyle(
                    color: getStatusColor(),
                    fontWeight:
                    FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// DESCRIPTION
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 14),

          /// BOTTOM
          Row(
            children: [

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                  Colors.teal.withOpacity(0.1),

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  serviceType,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                deadline,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}