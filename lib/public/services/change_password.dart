import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class AuthService {

  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String password,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/auth/reset_password");

      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
        };
      }

      final data =
      response.body.isNotEmpty ? jsonDecode(response.body) : {};

      return {
        "success": true,
        "message": data['message'] ?? "Password reset successful",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Error: $e",
      };
    }
  }
}