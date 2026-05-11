import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class TeamService {
  static Future<Map<String, dynamic>> fetchTeamsDetails(
      String phone,
      ) async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/users/tasks/single/$phone",
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      return jsonDecode(response.body);

    } else {

      throw Exception("Failed to load user details");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTeams() async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/tasks"),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List data = jsonDecode(response.body);

      return data.map<Map<String, dynamic>>((e) {
        return {
          "name": e['full_name'] ?? '',
          "role": e['role'] ?? '',
          "department": e['department'] ?? '',
          "tasks": e['_count']?['assigned_tasks'] ?? 0,
          "phone": e['phone'] ?? 'N/A',
        };
      }).toList();
    } else {
      throw Exception("Failed to load teams");
    }
  }
}