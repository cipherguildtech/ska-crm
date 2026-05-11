import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ska_crm/sales/sales_service.dart';

import '../active_projects/active_projects.dart';
import '../recent_customers/recent_customers.dart';
import 'widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SalesService salesService = SalesService();
  bool isLoading = true;
  Map<String, dynamic> data = {};
  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    data = await salesService.fetchDashboardData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDate =
        '${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().day}, ${DateTime.now().year}';
    final List<dynamic> resentCustomers = data['resentCustomers'] ?? [];
    final List<dynamic> activeProjectsDetailed =
        data['activeProjectsDetailed'] ?? [];
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
              Text(
                "Shree Krishna Ads • $currentDate",
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
                    value: data['totalCustomer'].toString(),
                    color: Colors.cyan.shade700,
                    icon: Icons.people_alt_outlined,
                  ),
                  StatCard(
                    title: "ACTIVE PROJECTS",
                    value: data['activeProjects'].toString(),
                    color: Colors.blueGrey.shade700,
                    icon: CupertinoIcons.briefcase,
                  ),
                  StatCard(
                    title: "PENDING QUOTATION",
                    value: data['pendingQuotations'].toString(),
                    color: Colors.brown.shade700,
                    icon: Icons.pending,
                  ),
                  StatCard(
                    title: "APPROVED DEALS",
                    value: data['approvedDeals'].toString(),
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
                RecentCustomers(),
                context,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: resentCustomers.length,
                itemBuilder: (context, index) {
                  final customer = resentCustomers[index];

                  return CustomerTile(
                    name: customer['name'],
                    mobile: customer['phone'],
                  );
                },
              ),

              const SizedBox(height: 24),

              /// Active Projects
              sectionHeader(
                "Active Projects",
                "View All",
                ActiveProjects(),
                context,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activeProjectsDetailed.length,
                itemBuilder: (context, index) {
                  final projects = activeProjectsDetailed[index];
                  final DateTime deadline = DateTime.parse(
                    projects['deadline'].toString(),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProjectCard(
                      code: projects['project_code'],
                      title: projects['customer']['name'].toString(),
                      status: projects['status'],
                      description: projects['description'],
                      date: deadline.isBefore(DateTime.now())
                          ? "Overdue: ${DateFormat('MMMM').format(deadline)} ${deadline.day}, ${deadline.year}"
                          : "Due: ${DateFormat('MMMM').format(deadline)} ${deadline.day}, ${deadline.year}",
                      isDelayed: deadline.isBefore(DateTime.now()),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Center(
              //   child: Text(
              //     "UPDATED 2 MINS AGO • HIGH CONTRAST MODE ACTIVE",
              //     style: TextStyle(fontSize: 12, color: Colors.teal),
              //   ),
              // ),
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
