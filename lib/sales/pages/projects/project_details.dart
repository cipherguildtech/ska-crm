import 'package:flutter/material.dart';
import 'package:ska_crm/sales/pages/projects/quotation.dart';
import 'package:ska_crm/sales/pages/projects/update_quotation.dart';

import '../../../admin/widgets/navbar.dart';
import 'cancel_quotation.dart';

class ProjectDashboard extends StatelessWidget {
  const ProjectDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "SKA-2025-0042",
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "ACTIVE",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            Text(
              "Project Dashboard",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            CustomerInfoCard(),
            SizedBox(height: 16),
            ProjectDetailsCard(),
            SizedBox(height: 16),
            ActionButtons(),
            SizedBox(height: 16),
            ProjectSummary(),
          ],
        ),
      ),
    );
  }
}

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key});

  Widget item(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00A8A8).withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  "CUSTOMER INFO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const Divider(),
            item(Icons.person, "PRIMARY CONTACT", "Alexander Sterling"),
            item(Icons.phone, "CONTACT NUMBER", "+1 (555) 234-8901"),
            item(
              Icons.location_on,
              "SITE ADDRESS",
              "722 Industrial Pkwy, Suite 400, Chicago, IL",
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsCard extends StatelessWidget {
  const ProjectDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "PROJECT DETAILS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SERVICE TYPE",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, color: primary, size: 15),
                        SizedBox(width: 5),
                        Text(
                          "Structural Engineering",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "DEADLINE",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.red,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Mar 28, 2025",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "OBJECTIVE",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Comprehensive seismic retrofitting for the main warehouse facility. Must comply with 2025 safety standards.",
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("PROJECT EVOLUTION"),
                Text("Stage 4 of 9", style: TextStyle(color: Colors.teal)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 4 / 9,
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  Widget button(
    Color textColor,
    Color bgColor,
    Color borderColor,
    IconData icon,
    String text,
    context,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (text == "QUOTATION") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuotationsScreen()),
            );
          }
          if (text == "UPDATE PROJECT") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QuotationScreen()),
            );
          }
          if (text == "REQUEST CANCEL") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RequestCancellationPage()),
            );
          }
        },

        child: Container(
          height: 75,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        button(
          Colors.white,
          Colors.teal,
          Colors.teal,
          Icons.quora,
          "QUOTATION",
          context,
        ),
        button(
          Colors.white,
          Colors.blue,
          Colors.blue,
          Icons.sync,
          "UPDATE PROJECT",
          context,
        ),
        button(
          Colors.red,
          Colors.white,
          Colors.red,
          Icons.cancel_outlined,
          "REQUEST CANCEL",
          context,
        ),
      ],
    );
  }
}

class ProjectSummary extends StatelessWidget {
  const ProjectSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Project Summary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Updated 2h ago",
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "The structural analysis for SKA-2025-0042 is complete. Material sourcing for high-tensile steel components is currently in progress.",
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "UPCOMING TASKS",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.circle, size: 10, color: Colors.orange),
              title: Text("Finalize Quotation #Q-992"),
              trailing: Text("Tomorrow"),
            ),
            ListTile(
              leading: Icon(Icons.circle, size: 10, color: Colors.grey),
              title: Text("Client Review Meeting"),
              trailing: Text("Fri, 14 Mar"),
            ),
          ],
        ),
      ),
    );
  }
}
