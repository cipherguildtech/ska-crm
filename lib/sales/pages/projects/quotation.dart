import 'package:flutter/material.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';

import 'create_quotation.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Proj: Metro Billboard",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                shadowColor: primary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateQuotationScreen()),
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
        children: const [
          InfoBanner(),
          SizedBox(height: 12),
          QuoteCard(
            id: "Q-2026-004",
            date: "Mar 24, 2026",
            amount: "\$12,500.00",
            status: Status.approved,
          ),
          QuoteCard(
            id: "Q-2026-003",
            date: "Mar 22, 2026",
            amount: "\$8,400.50",
            status: Status.sent,
            locked: true,
          ),
          QuoteCard(
            id: "Q-2026-002",
            date: "Mar 20, 2026",
            amount: "\$15,200.00",
            status: Status.rejected,
          ),
          QuoteCard(
            id: "Q-2026-001",
            date: "Mar 18, 2026",
            amount: "\$4,200.00",
            status: Status.draft,
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
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, size: 18, color: primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Only one quotation can be approved at a time.",
              style: TextStyle(
                fontSize: 13,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum Status { approved, sent, rejected, draft }

class QuoteCard extends StatelessWidget {
  final String id;
  final String date;
  final String amount;
  final Status status;
  final bool locked;

  const QuoteCard({
    super.key,
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    this.locked = false,
  });

  Color getStatusColor() {
    switch (status) {
      case Status.approved:
        return Colors.teal;
      case Status.sent:
        return Colors.blue;
      case Status.rejected:
        return Colors.red;
      case Status.draft:
        return Colors.grey;
    }
  }

  Widget getStatusText(Color color) {
    switch (status) {
      case Status.approved:
        return Row(
          children: [
            Icon(Icons.check_circle, color: color, size: 15),
            SizedBox(width: 5),
            Text("Approved", style: TextStyle(color: color)),
          ],
        );
      case Status.sent:
        return Row(
          children: [
            Icon(Icons.send, color: color, size: 15),
            SizedBox(width: 5),
            Text("Sent", style: TextStyle(color: color)),
          ],
        );
      case Status.rejected:
        return Row(
          children: [
            Icon(Icons.cancel_outlined, color: color, size: 15),
            SizedBox(width: 5),
            Text("Rejected", style: TextStyle(color: color)),
          ],
        );
      case Status.draft:
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
        color: status == Status.approved
            ? Colors.teal.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: status == Status.approved ? Colors.teal : Colors.grey.shade300,
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
                id,
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
                  Text(date),
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
                    amount,
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
          Wrap(spacing: 8, runSpacing: 8, children: _buildButtons()),
          if (locked)
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

  List<Widget> _buildButtons() {
    switch (status) {
      case Status.approved:
        return [_outlineButton("View")];

      case Status.sent:
        return [_outlineButton("View"), _dangerButton("Reject")];

      case Status.rejected:
        return [_outlineButton("View"), _outlineButton("Edit")];

      case Status.draft:
        return [
          _outlineButton("View"),
          _outlineButton("Edit"),
          _primaryButton("Send"),
          _dangerButton("Reject"),
        ];
    }
  }

  Widget _outlineButton(String text) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: text == "View" ? primary : Colors.black),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            text == "View" ? Icons.remove_red_eye_outlined : Icons.edit,
            color: text == "View" ? primary : Colors.black,
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: text == "View" ? primary : Colors.black,
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
      onPressed: () {},
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
      onPressed: () {},
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
