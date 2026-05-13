import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/config.dart';

class SalesService {
  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final uri = Uri.parse("$baseUrl/sales/dashboard");
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load dashboard: $e");
    }

    return {};
  }

  Future<List<dynamic>> fetchCustomers() async {
    try {
      final uri = Uri.parse("$baseUrl/customers");
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load customers: $e");
    }

    return [];
  }

  Future<List<dynamic>> fetchAllProjects() async {
    try {
      final uri = Uri.parse("$baseUrl/projects");
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load projects: $e");
    }

    return [];
  }

  Future<Map<String, dynamic>> fetchFullProjectByCode({
    required String code,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/projects/full/$code");

      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load projects: $e");
    }

    return {};
  }

  Future<Map<String, dynamic>> fetchProjectByCode({
    required String code,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/projects/$code");

      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load projects: $e");
    }

    return {};
  }

  Future<List<dynamic>> fetchQuotationsByCode({required String code}) async {
    try {
      final uri = Uri.parse("$baseUrl/quotation/all_by_code/$code");

      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load quotations: $e");
    }

    return [];
  }

  Future<Map<String, dynamic>> fetchQuotationsById({required String id}) async {
    try {
      final uri = Uri.parse("$baseUrl/quotation/all_by_id/$id");
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to load quotations: $e");
    }

    return {};
  }

  Future<Map<String, dynamic>> updateQuotationStatusById({
    required String id,
    required String status,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/quotation/update_status/$id/$status");
      final response = await http.put(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to update quotations: $e");
    }

    return {};
  }

  Future<Map<String, dynamic>> createQuotation({
    required String taskId,
    required double amount,
    double? advancePaid,
    String approvalStatus = "DRAFT",
    required List<String> pdfs,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quotation/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "task_id": taskId,
          "amount": amount,
          "advance_paid": advancePaid,
          "approval_status": approvalStatus,
          "pdf_url": pdfs,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> createPayment({
    required String projectId,
    String? quotationId,
    required double amount,
    required String type,
    String? reference,
    required DateTime paidAt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': projectId,
          'quotation_id': quotationId,
          'amount': amount,
          'type': type,
          'reference': reference,
          'paid_at': paidAt.toIso8601String(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProjectStatusById({
    required String id,
    required String status,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/projects/$id/status");
      final response = await http.put(uri, body: {"status": status});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      throw Exception("Failed to update quotations: $e");
    }

    return {};
  }

  static Future<Map<String, dynamic>?> createProjectHistory({
    String? projectId,
    String? projectCode,
    String? taskId,
    String? taskTitle,
    required String changedBy,
    required String taskOldStatus,
    required String taskNewStatus,
    String? detail,
    String? note,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/project-history/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "project_id": projectId,
          "project_code": projectCode,
          "task_id": taskId,
          "task_title": taskTitle,
          "changed_by": changedBy,
          "task_old_status": taskOldStatus,
          "task_new_status": taskNewStatus,
          "detail": detail,
          "note": note,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
