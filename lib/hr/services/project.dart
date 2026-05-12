import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class ProjectService {

  static Future<List<dynamic>> fetchProjects() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Failed to load projects",
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}