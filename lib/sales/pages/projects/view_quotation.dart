import 'package:flutter/material.dart';

import '../../sales_service.dart';

class ViewQuotation extends StatefulWidget {
  final String id;

  const ViewQuotation({super.key, required this.id});

  @override
  State<ViewQuotation> createState() => _ViewQuotationState();
}

class _ViewQuotationState extends State<ViewQuotation> {
  final SalesService salesService = SalesService();

  bool isLoading = true;

  Map<String, dynamic> quotations = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    quotations = await salesService.fetchQuotationsById(id: widget.id);

    setState(() {
      isLoading = false;
    });
  }

  String formatDate(String? date) {
    if (date == null) return "-";

    final parsed = DateTime.parse(date);

    return "${parsed.day}/${parsed.month}/${parsed.year}";
  }

  int calculateBalance() {
    final amount = int.tryParse(quotations['amount'].toString()) ?? 0;

    final advance = int.tryParse(quotations['advance_paid'].toString()) ?? 0;

    return amount - advance;
  }

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case "APPROVED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      case "PENDING":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = quotations['task'] as Map<String, dynamic>? ?? {};

    final payments = quotations['payments'] as List<dynamic>? ?? [];

    final status = quotations['approval_status']?.toString() ?? "PENDING";

    return Scaffold(
      backgroundColor: const Color(0xfff5f7f9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Quotation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// TASK DETAILS
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Task Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          task['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          task['notes'] ?? '',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),

                        const SizedBox(height: 20),

                        _infoRow("Department", task['department'] ?? '-'),

                        const SizedBox(height: 12),

                        _infoRow("Status", task['status'] ?? '-'),

                        const SizedBox(height: 12),

                        _infoRow("Due Date", formatDate(task['due_at'])),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// QUOTATION SUMMARY
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Quotation Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _priceRow(
                          "Quotation Amount",
                          "₹${quotations['amount']}",
                        ),

                        const SizedBox(height: 12),

                        _priceRow(
                          "Advance Paid",
                          "₹${quotations['advance_paid']}",
                        ),

                        const SizedBox(height: 20),

                        const Divider(),

                        const SizedBox(height: 10),

                        _priceRow(
                          "Balance Amount",
                          "₹${calculateBalance()}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// APPROVAL STATUS
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Approval Status",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: statusColor(status).withOpacity(0.12),

                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// PAYMENTS
                  if (payments.isNotEmpty)
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Payments",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          ...payments.map((payment) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),

                              padding: const EdgeInsets.all(14),

                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Column(
                                children: [
                                  _infoRow(
                                    "Reference",
                                    payment['reference'] ?? '-',
                                  ),

                                  const SizedBox(height: 10),

                                  _infoRow("Type", payment['type'] ?? '-'),

                                  const SizedBox(height: 10),

                                  _infoRow(
                                    "Paid Amount",
                                    "₹${payment['amount']}",
                                  ),

                                  const SizedBox(height: 10),

                                  _infoRow(
                                    "Paid At",
                                    formatDate(payment['paid_at']),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  /// PDF BUTTON
                  SizedBox(
                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        final pdf = quotations['pdf_url'];

                        debugPrint(pdf);
                      },

                      child: const Text(
                        "View PDF",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,

            fontSize: isBold ? 16 : 14,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,

            fontSize: isBold ? 18 : 15,
          ),
        ),
      ],
    );
  }
}
