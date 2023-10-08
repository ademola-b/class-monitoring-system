import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/department_response.dart';
import 'package:frontend/models/login_response.dart';
import 'package:frontend/models/student_response.dart';
import 'package:frontend/models/user_details_response.dart';
import 'package:frontend/services/urls.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RemoteServices {
  static Future<UserDetailsResponse?>? userDetails(context) async {
    try {
      Response response = await http.get(userUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return userDetailsResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An Error Occurred: $e", false));
    }
  }

  static Future<LoginResponse?> login(
      context, String username, String password) async {
    try {
      var response = await http
          .post(loginUrl, body: {'username': username, 'password': password});

      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);
          UserDetailsResponse? user_details =
              await RemoteServices.userDetails(context);
          if (user_details != null) {
            if (user_details.isStudent!) {
              Navigator.popAndPushNamed(context, '/studentNavbar');
            } else if (user_details.isLecturer!) {
              Navigator.popAndPushNamed(context, '/lecturerNavbar');
            } else if (user_details.isStaff!) {
              Navigator.popAndPushNamed(context, '/admin-dashboard');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.snackBar(context, "Invalid User Type", false));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                Constants.snackBar(context, "No user found", false));
          }
        }

        if (responseData['non_field_errors'] != null) {
          for (var element in responseData["non_field_errors"]) {
            ScaffoldMessenger.of(context)
                .showSnackBar(Constants.snackBar(context, "$element", false));
          }
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<List<DepartmentResponse>?>? departments(context) async {
    try {
      Response response = await http.get(deptsUrl, headers: {});
      if (response.statusCode == 200) {
        return departmentResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An Error Occurred: $e", false));
    }
  }

  static Future<StudentResponse?> createStudent(context,
      {List<Map<String, dynamic>>? data}) async {
    try {
      Response response = await http.post(
        createStudentUrl,
        body: jsonEncode(data),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Student Account Created Successfully", true));
      } else {
        var responseData = jsonDecode(response.body);
        print(responseData);
        for (var responses in responseData) {
          for (var element in responses.keys) {
            var value = responses[element];
            ScaffoldMessenger.of(context)
                .showSnackBar(Constants.snackBar(context, "$value", false));
          }
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
    return null;
  }
}
