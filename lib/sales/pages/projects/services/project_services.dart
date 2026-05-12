import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../utils/config.dart';

class ProjectService {

  Future<Map<dynamic, dynamic>?> createProject(Map<String,dynamic> customerDetails, Map<String, dynamic> projectDetails) async {
    final url1 = Uri.parse('$baseUrl/customers')
    final url3 = Uri.parse('$baseUrl/projects/create/$id');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> TaskDetail = jsonDecode(response.body);
      return TaskDetail;
    }
    else {
      return null;
    }

  }