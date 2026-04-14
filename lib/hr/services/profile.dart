import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class ProfileService {

   Future<Map<String, dynamic>?> fetchProfile(String phone) async {
    try {
      final uri = Uri.parse("$baseUrl/users/${Uri.encodeComponent(phone)}");

      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

   Future<Map<String, dynamic>> updateProfile({
    required String phone,
    required String name,
    required String email,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/users/${Uri.encodeComponent(phone)}");

      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
        }),
      );

      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "data": {"message": "Error: $e"},
      };
    }
  }
}