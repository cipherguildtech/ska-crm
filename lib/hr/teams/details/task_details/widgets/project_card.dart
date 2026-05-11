import 'package:flutter/material.dart';

bool hasValue(dynamic value) {
  if (value == null) return false;

  final text = value.toString().trim();

  return text.isNotEmpty &&
      text != "-" &&
      text != "0" &&
      text != "0.0" &&
      text.toLowerCase() != "null";
}

IconData statusIcon(String status) {
  switch (status.toUpperCase()) {
    case "PENDING":
      return Icons.schedule_rounded;

    case "IN_PROGRESS":
      return Icons.autorenew_rounded;

    case "REVIEW":
      return Icons.rate_review_rounded;

    case "COMPLETED":
      return Icons.check_circle_rounded;

    case "CANCELLED":
      return Icons.cancel_rounded;

    default:
      return Icons.info_rounded;
  }
}

Color statusColor(String status) {
  switch (status.toUpperCase()) {
    case "PENDING":
      return Colors.orange;

    case "IN_PROGRESS":
      return Colors.blue;

    case "REVIEW":
      return Colors.purple;

    case "COMPLETED":
      return Colors.green;

    case "CANCELLED":
      return Colors.red;

    default:
      return Colors.grey;
  }
}

Widget buildProjectCard(
    Map project,
    String Function(dynamic) formatDate,
    ) {
  final status = (project["status"] ?? "-").toString();

  return Container(
    margin: const EdgeInsets.only(bottom: 22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .05),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      children: [

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff0F766E),
                const Color(0xff14B8A6),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [


                  const Spacer(),

                  if (hasValue(status)) buildStatusBadge(status),
                ],
              ),

              if (hasValue(project["service_type"])) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    project["service_type"]
                        .toString()
                        .replaceAll("_", " ")
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],

              if (hasValue(project["project_code"]))
                Text(
                  project["project_code"].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .4,
                  ),
                ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [

              if (hasValue(project["description"])) ...[
                info(
                  "Description",
                  project["description"].toString(),
                ),
                const SizedBox(height: 16),
              ],

              if (hasValue(project["paid"]) ||
                  hasValue(project["balance"]))
                Row(
                  children: [
                    if (hasValue(project["paid"]))
                      Expanded(
                        child: statCard(
                          "Paid",
                          "₹${project["paid"]}",
                          Icons.payments_rounded,
                          Colors.green,
                        ),
                      ),

                    if (hasValue(project["paid"]) &&
                        hasValue(project["balance"]))
                      const SizedBox(width: 12),

                    if (hasValue(project["balance"]))
                      Expanded(
                        child: statCard(
                          "Balance",
                          "₹${project["balance"]}",
                          Icons.account_balance_wallet_rounded,
                          Colors.orange,
                        ),
                      ),
                  ],
                ),

              if (hasValue(project["paid"]) ||
                  hasValue(project["balance"]))
                const SizedBox(height: 16),

              if (hasValue(project["deadline"])) ...[
                infoTile(
                  Icons.calendar_month_rounded,
                  "Deadline",
                  formatDate(project["deadline"]),
                ),
                const SizedBox(height: 12),
              ],

              if (hasValue(project["created_at"])) ...[
                infoTile(
                  Icons.schedule_rounded,
                  "Created At",
                  formatDate(project["created_at"]),
                ),
                const SizedBox(height: 12),
              ],

              if (hasValue(project["updated_at"])) ...[
                infoTile(
                  Icons.update_rounded,
                  "Updated At",
                  formatDate(project["updated_at"]),
                ),
                const SizedBox(height: 18),
              ],

              if (hasValue(project["created_by"]?["full_name"]) ||
                  hasValue(project["created_by"]?["phone"]))
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xfff8fafc),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff0F766E),
                              Color(0xff14B8A6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Created By",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            if (hasValue(
                                project["created_by"]?["full_name"])) ...[
                              const SizedBox(height: 6),

                              Text(
                                project["created_by"]["full_name"]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],

                            if (hasValue(
                                project["created_by"]?["phone"])) ...[
                              const SizedBox(height: 4),

                              Text(
                                project["created_by"]["phone"]
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildStatusBadge(String status) {
  final color = statusColor(status);

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 9,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          statusIcon(status),
          color: color,
          size: 16,
        ),

        const SizedBox(width: 8),

        Text(
          status.replaceAll("_", " "),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xfff8fafc),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget info(
    String title,
    String value,
    ) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xfff8fafc),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget infoTile(
    IconData icon,
    String title,
    String value,
    ) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xfff8fafc),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [

        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Colors.teal,
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}