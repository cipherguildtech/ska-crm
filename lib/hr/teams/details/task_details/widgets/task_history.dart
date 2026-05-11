import 'dart:convert';

import 'package:flutter/material.dart';

class TaskHistory extends StatelessWidget {
  final List history;
  final String Function(dynamic) formatDate;

  const TaskHistory({
    super.key,
    required this.history,
    required this.formatDate,
  });

  bool isValidValue(dynamic value) {
    if (value == null) return false;

    final text = value.toString().trim();

    return text.isNotEmpty &&
        text != "0" &&
        text.toLowerCase() != "null";
  }

  @override
  Widget build(BuildContext context) {

    /// SORT BY DATE DESCENDING
    history.sort((a, b) {
      final aDate = DateTime.tryParse(
        a["changed_at"]?.toString() ?? "",
      ) ??
          DateTime.now();

      final bDate = DateTime.tryParse(
        b["changed_at"]?.toString() ?? "",
      ) ??
          DateTime.now();

      return bDate.compareTo(aDate);
    });
    return Column(
      children:
      history.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        final isLast =
            index == history.length - 1;

        final status =
            item["task_new_status"]
                ?.toString() ??
                "";

        final color =
        statusColor(status);

        String changedBy =
            item["changed_by"]?.toString() ?? "-";

        if (changedBy.startsWith("+91")) {
          changedBy =
              changedBy.replaceFirst("+91", "");
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// LEFT TIMELINE
              SizedBox(
                width: 95,

                child: Column(
                  children: [

                    /// DATE
                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),

                      decoration:
                      BoxDecoration(
                        color: color
                            .withValues(
                          alpha: .12,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
                          18,
                        ),
                      ),

                      child: Column(
                        children: [


                          const SizedBox(
                              height: 4),

                          Text(
                            formatDate(
                              item[
                              "changed_at"],
                            ),

                            textAlign:
                            TextAlign
                                .center,

                            style:
                            TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight:
                              FontWeight
                                  .bold,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,

                          margin:
                          const EdgeInsets
                              .symmetric(
                            vertical: 6,
                          ),

                          decoration:
                          BoxDecoration(
                            gradient:
                            LinearGradient(
                              begin: Alignment
                                  .topCenter,
                              end: Alignment
                                  .bottomCenter,

                              colors: [
                                color
                                    .withValues(
                                  alpha: .35,
                                ),
                                Colors.grey
                                    .shade200,
                              ],
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                              30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              /// CARD
              Expanded(
                child: Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 30,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius
                        .circular(28),

                    border: Border.all(
                      color: color
                          .withValues(
                        alpha: .08,
                      ),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: .05,
                        ),
                        blurRadius: 20,
                        offset:
                        const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [

                      /// HEADER
                      Container(
                        padding:
                        const EdgeInsets
                            .all(18),

                        decoration:
                        BoxDecoration(
                          gradient:
                          LinearGradient(
                            begin: Alignment
                                .topLeft,
                            end: Alignment
                                .bottomRight,

                            colors: [
                              color
                                  .withValues(
                                alpha: .14,
                              ),
                              color
                                  .withValues(
                                alpha: .05,
                              ),
                            ],
                          ),

                          borderRadius:
                          const BorderRadius
                              .only(
                            topLeft:
                            Radius
                                .circular(
                              28,
                            ),
                            topRight:
                            Radius
                                .circular(
                              28,
                            ),
                          ),
                        ),

                        child: Row(
                          children: [
                            const SizedBox(
                                width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(
                                    item["note"] ??
                                        "-",

                                    style:
                                    const TextStyle(
                                      fontSize:
                                      16,
                                      fontWeight:
                                      FontWeight
                                          .w800,
                                      height:
                                      1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// BODY
                      Padding(
                        padding:
                        const EdgeInsets
                            .all(18),

                        child: Column(
                          children: [

                            buildInfoTile(
                              Icons
                                  .compare_arrows_rounded,
                              "Old Status",
                              item["task_old_status"]
                                  ?.toString() ??
                                  "-",
                            ),

                            const SizedBox(
                                height: 14),

                            buildInfoTile(
                              Icons
                                  .flag_rounded,
                              "New Status",
                              item["task_new_status"]
                                  ?.toString() ??
                                  "-",
                            ),

                            const SizedBox(
                                height: 14),

                            buildInfoTile(
                              Icons.person_rounded,
                              "Changed By",
                              changedBy,
                            ),

                            /// DETAIL JSON
                            if (item["detail"] !=
                                null &&
                                item["detail"]
                                    .toString()
                                    .trim()
                                    .isNotEmpty) ...[
                              const SizedBox(
                                  height: 14),

                              buildDetailTile(
                                item["detail"]
                                    .toString(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Widget buildInfoTile(
    IconData icon,
    String title,
    String value,
    ) {
  return Container(
    padding:
    const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: const Color(0xfff8fafc),

      borderRadius:
      BorderRadius.circular(20),
    ),

    child: Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Container(
          padding:
          const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: Colors.teal
                .withValues(alpha: .08),

            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          child: Icon(
            icon,
            size: 18,
            color: Colors.teal,
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
                  color:
                  Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value,

                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildInfo(
    String title,
    String value,
    ) {
  return Container(
    padding:
    const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: const Color(0xfff8fafc),

      borderRadius:
      BorderRadius.circular(20),
    ),

    child: Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: TextStyle(
                  color:
                  Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                value,

                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget buildDetailTile(String detail) {
  String reason = "-";
  String workDetail = "-";

  try {
    final raw = jsonDecode(detail);

    if (raw is Map) {
      final map = raw.map((k, v) =>
          MapEntry(k.toString().toLowerCase(), v));

      reason = _safe(map, ["reason"]);
      workDetail = _safe(map, ["workdetail", "work_detail"]);
    }
  } catch (_) {
    final cleaned = detail
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "");

    final parts = cleaned.split(",");

    for (var part in parts) {
      final kv = part.split(":");
      if (kv.length < 2) continue;

      final key = kv[0].trim().toLowerCase();
      final value = kv.sublist(1).join(":").trim();

      if (key.contains("reason")) {
        reason = value.isNotEmpty ? value : "-";
      }

      if (key.contains("work")) {
        workDetail = value.isNotEmpty ? value : "-";
      }
    }
  }

  return Column(
    children: [
      buildInfo(
        "Reason",
        reason,
      ),
      const SizedBox(height: 14),
      buildInfo(
        "Work Detail",
        workDetail,
      ),
    ],
  );
}

/// helper
String _safe(Map<String, dynamic> map, List<String> keys) {
  for (final k in keys) {
    final value = map[k];
    if (value != null &&
        value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return "-";
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