import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ska_crm/utils/config.dart';
import 'customers_details.dart';

class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String customerType;
  final String referal;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.customerType,
    required this.referal,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      customerType: json['customer_type'] ?? '',
      referal: json['referal'] ?? '',
    );
  }
}

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  String selectedFilter = "All";
  String searchQuery = "";

  List<Customer> allCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          "$baseUrl/customers",
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        allCustomers = data
            .map((e) => Customer.fromJson(e))
            .toList();

        setState(() {});
      }
    } catch (e) {
      debugPrint("Error fetching customers: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Customer> get filteredCustomers {
    return allCustomers.where((customer) {
      final matchesSearch =
          customer.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          customer.phone.contains(searchQuery);

      final matchesFilter = selectedFilter == "All"
          ? true
          : customer.customerType.toLowerCase() ==
          selectedFilter.toLowerCase();

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
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        title: const Text("Customers"),
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
              children: ["All", "WALKIN", "REFERRAL", "EXISTING"]
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
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : filteredCustomers.isEmpty
                  ? const Center(
                child: Text("No customers found"),
              )
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

  const CustomerCard({
    super.key,
    required this.customer,
  });

  Color getTypeColor() {
    switch (customer.customerType.toUpperCase()) {
      case "EXISTING":
        return Colors.green;
      case "REFERRAL":
        return Colors.orange;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailsPage(
              phoneNumber: customer.phone,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [

            /// TOP SECTION
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.teal.shade400,
                    Colors.teal.shade600,
                  ],
                ),
              ),
              child: Row(
                children: [

                  /// AVATAR
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// NAME + PHONE
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 15,
                              color: Colors.white70,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                customer.phone,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// TYPE BADGE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(30),
                    ),
                    child: Text(
                      customer.customerType,
                      style: TextStyle(
                        color: getTypeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  /// EMAIL
                  infoTile(
                    icon: Icons.email_outlined,
                    title: "Email",
                    value: customer.email,
                    iconColor: Colors.orange,
                  ),

                  const SizedBox(height: 14),

                  /// ADDRESS
                  infoTile(
                    icon: Icons.location_on_outlined,
                    title: "Address",
                    value: customer.address,
                    iconColor: Colors.redAccent,
                  ),

                  const SizedBox(height: 14),

                  /// REFERRAL
                  infoTile(
                    icon: Icons.groups_2_outlined,
                    title: "Referral",
                    value: customer.referal,
                    iconColor: Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget infoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value.isEmpty ? "-" : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}