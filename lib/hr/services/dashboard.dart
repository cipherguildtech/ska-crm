import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class DashboardService {

  Future<Map<String, dynamic>> fetchDashboard() async {
    try {
      final uri = Uri.parse("$baseUrl/tasks/dashboard/hr");

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": data,
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ??
              "Server error: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error: $e",
      };
    }
  }

  Future<List> fetchTeams() async {
    try {
      final uri = Uri.parse("$baseUrl/tasks/elaborate_teams");
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data;
        } else if (data is Map && data['teams'] != null) {
          return data['teams'];
        }
      }
    } catch (e) {
      throw Exception("Failed to load teams: $e");
    }

    return [];
  }
}