import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';

import 'widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Work Status",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Shree Krishna Ads • April 05, 2026",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              /// Stats Grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                children: [
                  StatCard(
                    title: "TOTAL CUSTOMERS",
                    value: "124",
                    color: Colors.cyan.shade700,
                    icon: Icons.people_alt_outlined,
                  ),
                  StatCard(
                    title: "ACTIVE PROJECTS",
                    value: "38",
                    color: Colors.blueGrey.shade700,
                    icon: CupertinoIcons.briefcase,
                  ),
                  StatCard(
                    title: "PENDING QUOTATION",
                    value: "14",
                    color: Colors.brown.shade700,
                    icon: Icons.pending,
                  ),
                  StatCard(
                    title: "APPROVED DEALS",
                    value: "89",
                    color: Colors.lightGreen.shade700,
                    icon: CupertinoIcons.check_mark_circled,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Recent Customers
              sectionHeader(
                "Recent Customers",
                "See all",
                DashboardScreen(),
                context,
              ),
              const SizedBox(height: 12),
              const CustomerTile(name: "Marcus Holloway"),
              const CustomerTile(name: "Sarah Chen"),

              const SizedBox(height: 24),

              /// Active Projects
              sectionHeader(
                "Active Projects",
                "View All",
                DashboardScreen(),
                context,
              ),
              const SizedBox(height: 12),

              const ProjectCard(
                title: "Global Tech Solutions",
                status: "Delayed",
                description:
                    "Infrastructure upgrade phase 2. Deployment of 5G networking modules and edge server",
                date: "Overdue: Oct 12, 2025",
                isDelayed: true,
              ),

              const SizedBox(height: 12),

              const ProjectCard(
                title: "Nexus Retail Group",
                status: "In Progress",
                description:
                    "Point-of-sale system integration for 15 regional outlets. Currently in UAT phase.",
                date: "Deadline: Oct 28, 2025",
                isDelayed: false,
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "UPDATED 2 MINS AGO • HIGH CONTRAST MODE ACTIVE",
                  style: TextStyle(fontSize: 12, color: primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(String title, String action, Widget route, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => route));
          },
          child: Text(action, style: const TextStyle(color: Colors.teal)),
        ),
      ],
    );
  }
}
