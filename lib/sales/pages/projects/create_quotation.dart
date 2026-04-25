import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ska_crm/admin/widgets/navbar.dart';

class CreateQuotationScreen extends StatelessWidget {
  const CreateQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Quotation",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "Proj: Metro Billboard",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.info_outline, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LINE ITEMS HEADER
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "LINE ITEMS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "2 Items",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// ITEM CARD 1
            const ItemCard(
              title: "Banner design - Monsoon Camp",
              qty: "1",
              price: "5000",
              total: "5,000.00",
            ),

            /// ITEM CARD 2
            const ItemCard(
              title: "Social Media Ad Placement (30)",
              qty: "3",
              price: "1200",
              total: "3,600.00",
            ),

            const SizedBox(height: 12),

            /// ADD NEW ITEM BUTTON
            DottedBorder(
              color: Colors.teal,
              strokeWidth: 1,
              dashPattern: [6, 3], // dash length, gap
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: const Center(
                  child: Text(
                    "+ Add New Item",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SUMMARY
            const Text(
              "SUMMARY",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  SummaryRow(label: "Subtotal", value: "₹8,600.00"),
                  SummaryRow(label: "GST (18%)", value: "₹1,548.00"),
                  Divider(),
                  SizedBox(height: 8),
                  TotalBox(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// NOTES
            const Text(
              "NOTES / TERMS",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 10),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Add payment terms, delivery notes, or internal comments...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// BUTTONS
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text(
                "Send to Customer",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.teal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.save, color: Colors.teal),
              label: const Text(
                "Save as Draft",
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- ITEM CARD ----------------
class ItemCard extends StatelessWidget {
  final String title, qty, price, total;

  const ItemCard({
    super.key,
    required this.title,
    required this.qty,
    required this.price,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(title),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.delete_outline_outlined, color: Colors.red),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _inputBox("QTY", qty),
              _inputBox("UNIT PRICE", "₹ $price"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "TOTAL",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "₹$total",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value),
        ),
      ],
    );
  }
}

/// ---------------- SUMMARY ROW ----------------
class SummaryRow extends StatelessWidget {
  final String label, value;

  const SummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

/// ---------------- TOTAL BOX ----------------
class TotalBox extends StatelessWidget {
  const TotalBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TOTAL AMOUNT",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Includes all applicable taxes",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Text(
            "₹10,148.00",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
