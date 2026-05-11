import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final Map payment;

  final String Function(dynamic) formatDate;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.formatDate,
  });

  String safeValue(dynamic value) {

    if (value == null) return "-";

    final text = value.toString().trim();

    if (
    text.isEmpty ||
        text.toLowerCase() == "null" ||
        text == "-" ||
        text == "0" ||
        text == "0.0"
    ) {
      return "-";
    }

    return text;
  }

  String safeDate(dynamic value) {

    final safe = safeValue(value);

    if (safe == "-") return "-";

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

  @override
  Widget build(BuildContext context) {

    final amount = safeValue(
      payment["amount"],
    );

    final type = safeValue(
      payment["type"],
    );

    final reference = safeValue(
      payment["reference"],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [

          /// TOP HEADER
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),

              gradient: LinearGradient(
                colors: [
                  Colors.green.shade700,
                  Colors.green.shade500,
                ],
              ),
            ),

            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: .15,
                    ),

                    borderRadius:
                    BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.payments_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Payment",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        type,

                        style: TextStyle(
                          color: Colors.white
                              .withValues(alpha: .85),

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(30),
                  ),

                  child: Text(
                    amount == "-"
                        ? "-"
                        : "₹$amount",

                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              children: [

                buildInfoTile(
                  Icons.receipt_long_rounded,
                  "Reference",
                  reference,
                ),

                buildInfoTile(
                  Icons.calendar_today_rounded,
                  "Created At",
                  safeDate(
                    payment["created_at"],
                  ),
                ),

                buildInfoTile(
                  Icons.check_circle_rounded,
                  "Paid At",
                  safeDate(
                    payment["paid_at"],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.green.withValues(
                alpha: .1,
              ),

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: Colors.green,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

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

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}