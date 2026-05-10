import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class TaskDetailService {

  Future<Map<dynamic, dynamic>?> fetchTask(String id) async {
    final url = Uri.parse('$baseUrl/tasks/single/$id');
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

  Future<bool> changeTaskStatus(String id, String status, String workDetail, String? delayReason, String projectId, String changedBy, String oldStatus, List<File>? files) async {
    List<String> base64Images = [];
    for (File image in files!) {
      final bytes = await image.readAsBytes();
      final base64 = base64Encode(bytes);
      base64Images.add(base64);
    }
    final url1 = Uri.parse('$baseUrl/tasks/update_status/$id/$status/${status == 'COMPLETED' ?((DateTime.now()).toString()): null}');
    final url2 = Uri.parse('$baseUrl/tasks/update/$id');
    final url3 = Uri.parse('$baseUrl/project-history/create');
    final url4 = Uri.parse('$baseUrl/tasks/save_files/$id');
    try {
      final response1 = await http.put(
        url1,
        headers: {
          "Content-Type": "application/json",
        },
      );

      final response2 = await http.put(
          url2,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {
                'work_details': workDetail,
                'notes_work': delayReason,
              }
          )
      );

      final response3 = await http.post(
          url3,
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {
                'task_id': id,
                'project_id': projectId,
                'changed_by': changedBy,
                'task_old_status': oldStatus,
                'task_new_status': status,
                'detail': {
                  'reason': status == 'COMPLETED' ? 'completed' : 'in_progress',
                  'work_details': workDetail
                },
              }
          )
      );

      final response4 = await http.post(
          url4,
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {
                'images': base64Images.isEmpty ? null : base64Images
              }
          )
      );


      print(response4.statusCode);
      if (response1.statusCode == 200 && response2.statusCode == 200 &&
          response3.statusCode == 201 && response4.statusCode == 201) {
        return true;
      }
      else {
        return false;
      }
    }
    catch(e) {
      print(e);
      return false;
    }

  }

}