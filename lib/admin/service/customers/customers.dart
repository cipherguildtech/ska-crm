import 'package:flutter/material.dart';

import 'customers_details.dart';

class Customer {
  final String name;
  final String phone;
  final String location;
  final int projects;
  final String type; // recent, existing, vip

  Customer({
    required this.name,
    required this.phone,
    required this.location,
    required this.projects,
    required this.type,
  });
}

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  String selectedFilter = "All";
  String searchQuery = "";

  final List<Customer> allCustomers = [
    Customer(
      name: "Acme Retail Pvt Ltd",
      phone: "+91 98765 43210",
      location: "MG Road, Mumbai",
      projects: 3,
      type: "existing",
    ),
    Customer(
      name: "BrightMart Stores",
      phone: "+91 91234 56789",
      location: "Indiranagar, Bengaluru",
      projects: 1,
      type: "recent",
    ),
    Customer(
      name: "Jiva Wellness Center",
      phone: "+91 99876 54321",
      location: "",
      projects: 0,
      type: "vip",
    ),
    Customer(
      name: "Skyline Architects",
      phone: "+91 88776 55443",
      location: "Sector 44, Gurgaon",
      projects: 5,
      type: "existing",
    ),
  ];

  List<Customer> get filteredCustomers {
    return allCustomers.where((customer) {
      final matchesSearch =
          customer.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          customer.phone.contains(searchQuery);

      final matchesFilter = selectedFilter == "All"
          ? true
          : customer.type.toLowerCase() == selectedFilter.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void updateSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  void updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Customers", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 SEARCH
            TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: "Search by name or phone number",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🎯 FILTERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["All", "Recent", "Existing", "VIP"]
                  .map(
                    (filter) => GestureDetector(
                      onTap: () => updateFilter(filter),
                      child: FilterChipWidget(
                        label: filter,
                        selected: selectedFilter == filter,
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            /// LIST
            Expanded(
              child: filteredCustomers.isEmpty
                  ? const Center(child: Text("No customers found"))
                  : ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (_, index) {
                        final c = filteredCustomers[index];
                        return CustomerCard(customer: c);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.teal.shade50 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.teal : Colors.black87),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CustomerDetailsPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NAME + BADGE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${customer.projects} Projects",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// PHONE
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.teal),
                const SizedBox(width: 6),
                Text(customer.phone),
              ],
            ),

            if (customer.location.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(child: Text(customer.location)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
