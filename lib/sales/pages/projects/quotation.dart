import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ska_crm/sales/pages/projects/view_quotation.dart';

import '../../sales_service.dart';
import 'create_quotation.dart';

class QuotationsScreen extends StatefulWidget {
  final String code;
  const QuotationsScreen({super.key, required this.code});
  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  final SalesService salesService = SalesService();
  bool isLoading = true;
  List<dynamic> quotations = [];
  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    quotations = await salesService.fetchQuotationsByCode(code: widget.code);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
        title: Text(
          widget.code,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                shadowColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateQuotationScreen(
                      taskId: quotations[0]['task_id'],
                      projectId: quotations[0]['task']['project_id'],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                "Create",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoBanner(),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quotations.length,
            itemBuilder: (context, index) {
              final quotation = quotations[index];
              final date = DateTime.parse(quotation['created_at'].toString());
              final createdDate =
                  '${DateFormat('MMMM').format(date)} ${date.day}, ${date.year}';

              return QuoteCard(
                id: quotation['id'],
                title: quotation['task']['title'],
                date: createdDate,
                amount: "₹ ${quotation['amount']}",
                status: Status.values.firstWhere(
                  (e) => e.name == quotation['approval_status'],
                ),
                onStatusUpdated: init,
              );
            },
          ),
        ],
      ),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, size: 18, color: Colors.teal),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Only one quotation can be approved at a time.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Status { DRAFT, SENT, APPROVED, REJECTED }

class QuoteCard extends StatefulWidget {
  final String title;
  final String id;
  final String date;
  final String amount;
  final Status status;
  final bool locked;
  final VoidCallback onStatusUpdated;

  const QuoteCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.locked = false,
    required this.id,
    required this.onStatusUpdated,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final SalesService salesService = SalesService();

  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {
    final res = await salesService.updateQuotationStatusById(
      id: id,
      status: status,
    );
    if (res.isNotEmpty) {
      widget.onStatusUpdated();
    }
  }

  Color getStatusColor() {
    switch (widget.status) {
      case Status.APPROVED:
        return Colors.teal;
      case Status.SENT:
        return Colors.blue;
      case Status.REJECTED:
        return Colors.red;
      case Status.DRAFT:
        return Colors.grey;
    }
  }

  Widget getStatusText(Color color) {
    switch (widget.status) {
      case Status.APPROVED:
        return Row(
          children: [
            Icon(Icons.check_circle, color: color, size: 15),
            SizedBox(width: 5),
            Text("Approved", style: TextStyle(color: color)),
          ],
        );
      case Status.SENT:
        return Row(
          children: [
            Icon(Icons.send, color: color, size: 15),
            SizedBox(width: 5),
            Text("Sent", style: TextStyle(color: color)),
          ],
        );
      case Status.REJECTED:
        return Row(
          children: [
            Icon(Icons.cancel_outlined, color: color, size: 15),
            SizedBox(width: 5),
            Text("Rejected", style: TextStyle(color: color)),
          ],
        );
      case Status.DRAFT:
        return Row(
          children: [
            Icon(Icons.save, color: color, size: 15),
            SizedBox(width: 5),
            Text("Draft", style: TextStyle(color: color)),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.status == Status.APPROVED
            ? Colors.teal.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.status == Status.APPROVED
              ? Colors.teal
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: getStatusText(color),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CREATED DATE",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.date),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "TOTAL AMOUNT",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.amount,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 24),

          /// Buttons
          Wrap(spacing: 8, runSpacing: 8, children: _buildButtons(context)),
          if (widget.locked)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Approval locked - one already approved",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    switch (widget.status) {
      case Status.APPROVED:
        return [_outlineButton("View", widget.id, context)];

      case Status.SENT:
        return [
          _outlineButton("View", widget.id, context),
          _dangerButton("Reject"),
        ];

      case Status.REJECTED:
        return [_outlineButton("View", widget.id, context)];

      case Status.DRAFT:
        return [
          _outlineButton("View", widget.id, context),
          // _outlineButton("Edit", id, context),
          _primaryButton("Send"),
          _dangerButton("Reject"),
        ];
    }
  }

  Widget _outlineButton(String text, String id, BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: text == "View" ? Colors.teal : Colors.black),
        ),
      ),
      onPressed: () {
        if (text == "View") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ViewQuotation(id: id)),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            text == "View" ? Icons.remove_red_eye_outlined : Icons.edit,
            color: text == "View" ? Colors.teal : Colors.black,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: text == "View" ? Colors.teal : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String text) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        side: WidgetStateProperty.all(BorderSide(color: Colors.blue)),
      ),
      onPressed: () {
        if (text == 'Send') {
          updateStatus(id: widget.id, status: 'SENT');
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.send, color: Colors.blue, size: 15),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _dangerButton(String text) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        side: WidgetStateProperty.all(BorderSide(color: Colors.red)),
      ),
      onPressed: () {
        if (text == 'Reject') {
          updateStatus(id: widget.id, status: 'REJECTED');
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red, size: 15),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
