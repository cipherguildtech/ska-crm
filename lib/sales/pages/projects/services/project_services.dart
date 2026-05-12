import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/config.dart';

class ProjectService {

  Future<bool> createProject(Map<String,dynamic> customerDetails, Map<String, dynamic> projectDetails) async {
    print('entered');
    final pref = await SharedPreferences.getInstance();
    final phone = pref.get('phone');
    final url1 = Uri.parse('$baseUrl/customers/${customerDetails['phone']}');
    final url2 = Uri.parse('$baseUrl/customers');
    final url3 = Uri.parse('$baseUrl/projects');
    final isCustomerExists = await http.get(
      url1,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (isCustomerExists.statusCode == 404) {
      print('customer not');
      final customer = await http.post(
          url2,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              customerDetails
          )
      );
      print(customer.body);
      if (customer.statusCode == 201) {
        print('customer created');
        final project = await http.post(
            url3,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(
                {
                  ...projectDetails,
                  'created_user_phone': phone,
                  'customer_phone': customerDetails['phone']
                }
            )
        );
        print(project);
        if(project.statusCode == 201) {
          return true;
        }
        else {
          return false;
        }
      }
      return false;
    }
    else if (isCustomerExists.statusCode == 200) {
      final project = await http.post(
          url3,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(
              {
                ...projectDetails,
                'created_user_phone': phone,
                'customer_phone': customerDetails['phone']
              }
          )
      );
      if(project.statusCode == 201) {
        return true;
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }
  }
  }