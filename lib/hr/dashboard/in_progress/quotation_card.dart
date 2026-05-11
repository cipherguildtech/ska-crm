import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_card.dart';

class QuotationCard extends StatelessWidget {
  final Map quotation;

  final String Function(dynamic) formatDate;

  const QuotationCard({
    super.key,
    required this.quotation,
    required this.formatDate,
  });
  String safeDate(dynamic value) {

    if (value == null) return "-";

    final text = value.toString().trim();

    if (
    text.isEmpty ||
        text == "null" ||
        text == "-" ||
        text == "0" ||
        text == "0000-00-00" ||
        text == "0000-00-00 00:00:00"
    ) {
      return "-";
    }

    try {

      final formatted = formatDate(value);

      if (
      formatted.contains("1970") ||
          formatted.contains("00:00")
      ) {
        return "-";
      }

      return formatted;

    } catch (_) {

      return "-";
    }
  }

  List<dynamic> parseList(dynamic data) {
    if (data == null) return [];

    if (data is List) return data;

    if (data is String) {
      try {
        final decoded = jsonDecode(data);

        if (decoded is List) {
          return decoded;
        }
      } catch (_) {}
    }

    return [];
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final payments = parseList(
      quotation["payments"],
    );

    final pdfs = parseList(
      quotation["pdf_url"],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          /// HEADER
          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: .1),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Quotation",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      quotation["approval_status"] ?? "-",

                      style: TextStyle(
                        color: approvalColor(
                          quotation["approval_status"],
                        ),

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          /// DETAILS
          buildInfo(
            "Amount",
            "₹${quotation["amount"] ?? "-"}",
          ),

          buildInfo(
            "Advance Paid",
            "₹${quotation["advance_paid"] ?? "-"}",
          ),

          buildInfo(
            "Approved At",
            safeDate(
              quotation["approved_at"],
            ),
          ),

          buildInfo(
            "Created At",
            safeDate(
              quotation["created_at"],
            ),
          ),

          buildInfo(
            "Updated At",
            safeDate(
              quotation["updated_at"],
            ),
          ),

          /// PDFS
          if (pdfs.isNotEmpty) ...[
            const SizedBox(height: 20),

            sectionTitle("PDF Files"),

            const SizedBox(height: 10),

            ...pdfs.map((pdf) {
              return buildFileCard(
                pdf.toString(),
              );
            }),
          ] else if (
          quotation["pdf_url"] != null
          ) ...[
              const SizedBox(height: 20),

              sectionTitle("PDF File"),

              const SizedBox(height: 10),

              buildFileCard(
                quotation["pdf_url"].toString(),
              ),
            ],

          /// PAYMENTS
          if (payments.isNotEmpty) ...[
            const SizedBox(height: 22),

            sectionTitle("Payments"),

            const SizedBox(height: 12),

            ...payments.map((payment) {
              return PaymentCard(
                payment: payment,
                formatDate: formatDate,
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildInfo(
      String title,
      dynamic value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 120,

            child: Text(
              "$title :",

              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value?.toString() ?? "-",

              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFileCard(String url) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),

      onTap: () {
        openUrl(url);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.grey.shade100,

          borderRadius: BorderRadius.circular(14),
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: .1),

                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.red,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                url,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.open_in_new_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color approvalColor(dynamic status) {

    switch (
    status.toString().toUpperCase()
    ) {

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
}