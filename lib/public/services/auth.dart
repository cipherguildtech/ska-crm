import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class AuthService {

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/auth/login");

      String formattedPhone = phone.trim();

      if (!formattedPhone.startsWith("+91")) {
        formattedPhone = "+91$formattedPhone";
      }


      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": formattedPhone,
          "password": password,
        }),
      );

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": data,
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Login failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error: $e",
      };
    }
  }

  Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/auth/send_otp");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      final data =
      response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": data,
          "message": data['message'] ?? "OTP sent successfully",
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

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/auth/verify_otp");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final data =
      response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": data,
          "message": data['message'] ?? "OTP Verified",
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "Verification failed",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error: $e",
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/auth/reset_password");

      final response = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
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