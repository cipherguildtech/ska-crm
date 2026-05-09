import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class TaskDetailService {

  Future<Map<dynamic, dynamic>?> fetchTask(String id) async {
    final url = Uri.parse('$baseUrl/tasks/single/${id}');
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

}