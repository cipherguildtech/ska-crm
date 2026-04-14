import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ska_crm/utils/config.dart';

class SessionService {

  Future<Map<String, dynamic>> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "role": prefs.getString('role'),
      "department": prefs.getString('department'),
      "phone": prefs.getString('phone'),
    };
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>> validateUser(String phone) async {
    try {
      final url = Uri.parse('$baseUrl/users/${Uri.encodeComponent(phone)}');

      final response =
      await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return {
          "success": true,
          "isActive": data['is_active'] ?? false,
          "reason": data['userBlockReason'] ?? '',
        };
      }

      return {
        "success": false,
        "message": "Server error: ${response.statusCode}"
      };
    } on SocketException {
      return {"success": false, "message": "No Internet connection"};
    } on TimeoutException {
      return {"success": false, "message": "Server timeout"};
    } catch (e) {
      return {"success": false, "message": "Something went wrong"};
    }
  }

}