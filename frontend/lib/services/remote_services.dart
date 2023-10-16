import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/attendance_report_response.dart';
import 'package:frontend/models/attendance_response.dart';
import 'package:frontend/models/course_response.dart';
import 'package:frontend/models/department_response.dart';
import 'package:frontend/models/full_student_detail_response.dart';
import 'package:frontend/models/full_user_response.dart';
import 'package:frontend/models/lecturer_response.dart';
import 'package:frontend/models/login_response.dart';
import 'package:frontend/models/password_change_response.dart';
import 'package:frontend/models/student_qr_response.dart';
import 'package:frontend/models/student_response.dart';
import 'package:frontend/models/user_details_response.dart';
import 'package:frontend/services/urls.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RemoteServices {
  static Future<UserDetailsResponse?>? userDetails(context) async {
    try {
      Response response = await http.get(userUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return userDetailsResponseFromJson(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to get user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An Error Occurred: $e", false));
    }
  }

  static Future<FullUserDetailResponse?>? fullUserDetails(context) async {
    try {
      Response response = await http.get(fullUserUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return fullUserDetailResponseFromJson(response.body);
      } else {
        print(response.body);
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
              sharedPreferences.setBool("staff", user_details.isStaff);
              Navigator.popAndPushNamed(context, '/studentNavbar');
            } else if (user_details.isLecturer!) {
              sharedPreferences.setBool("staff", user_details.isStaff);
              Navigator.popAndPushNamed(context, '/lecturerNavbar');
            } else if (user_details.isStaff) {
              sharedPreferences.setBool("staff", user_details.isStaff);
              Navigator.popAndPushNamed(context, '/adminNavbar');
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

  static Future<List<CoursesResponse>?>? courses(context) async {
    try {
      Response response = await http.get(coursesUrl, headers: {});
      if (response.statusCode == 200) {
        return coursesResponseFromJson(response.body);
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
        Navigator.pop(context);
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

  static Future<StudentResponse?> createLecturer(context,
      {List<Map<String, dynamic>>? data}) async {
    try {
      Response response = await http.post(
        createLecturerUrl,
        body: jsonEncode(data),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Lecturer Account Created Successfully", true));
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

  static Future<String> getQrImageBytes(String regNo) async {
    final QrPainter painter = QrPainter(
      data: regNo,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    final img = await painter.toImageData(200);

    return base64Encode(img!.buffer.asUint8List());
  }

  static Future<void> saveQrImage(context, String regNo) async {
    final qrImageData = await getQrImageBytes(regNo);

    try {
      var request = http.MultipartRequest('POST', saveStudentQr);
      request.fields['registration_no'] = regNo;
      request.files.add(http.MultipartFile(
        'qr_image',
        http.ByteStream.fromBytes(
            Uint8List.fromList(base64.decode(qrImageData))),
        base64.decode(qrImageData).length,
        filename: 'qr_image.png', // You can choose any filename here
        // contentType: MediaType('image', 'png'), // Specify the correct content type
      ));

      final response = await request.send();

      print(response.stream.toString());
      if (response.statusCode == 201) {
        // Handle a successful response
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Student's Qr Saved Successfully", true));
        // print('QrImage sent successfully');
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Fail to Save Student's QrCode", false));
        print('Failed to send QrImage to the API');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<List<StudentQrResponse>?> studentQr(context) async {
    try {
      Response response = await http.get(saveStudentQr, headers: {
        "Authorization": "Token ${sharedPreferences.getString('token')}"
      });

      if (response.statusCode == 200) {
        return studentQrResponseFromJson(response.body);
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<FullStudentResponse?> studentDetail(
      context, String regNo) async {
    try {
      Response response = await http.get(
          Uri.parse("$baseUrl/api/accounts/student-detail/?username=$regNo"));
      if (response.statusCode == 200) {
        return fullStudentResponseFromJson(response.body);
      } else {
        
        var responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
              context, "An error occurred: can't get student detail", false));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<AttendanceResponse?> markAttendance(
      context, String student, String course) async {
    try {
      Response response = await http.post(markAttendanceUrl, body: {
        'student': student,
        'course': course,
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "Attendance successfully marked", true));
        return attendanceResponseFromJson(response.body);
      } else {
        var responseData = jsonDecode(response.body);
        print("darae $responseData");
        if (responseData['detail'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "${responseData['detail']}", false));
        }
      }
    } catch (e) {
      print("err: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<List<LecturerResponse>?> lecturerDetail(context) async {
    try {
      Response response = await http.get(lecturerDetailUrl, headers: {
        "Authorization": "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return lecturerResponseFromJson(response.body);
      } else {
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(Constants.snackBar(
            context, "An error occurred: ${response.body}", false));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<List<AttendanceReportResponse>?> attendanceList(
      context, String from, String to,
      {String? course}) async {
    try {
      if (course == null) {
        Response response = await http
            .get(Uri.parse("$baseUrl/api/report/?from=$from&to=$to"), headers: {
          "Authorization": "Token ${sharedPreferences.getString('token')}"
        });
        if (response.statusCode == 200) {
          print(jsonDecode(response.body));
          return attendanceReportResponseFromJson(response.body);
        } else {
          throw Exception("Failed to get attendance history");
        }
      } else {
        Response response = await http.get(
            Uri.parse("$baseUrl/api/report/?from=$from&to=$to&course=$course"),
            headers: {
              "Authorization": "Token ${sharedPreferences.getString('token')}"
            });
        if (response.statusCode == 200) {
          print(jsonDecode(response.body));
          return attendanceReportResponseFromJson(response.body);
        } else {
          throw Exception("Failed to get attendance history");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", false));
    }
  }

  static Future<PasswordChangeResponse?> passwordChange(
      context, String? oldPass, String? newPass, String? conPass) async {
    try {
      Response response = await http.post(passwordChangeUrl,
          headers: <String, String>{
            "content-type": "application/json; charset=UTF-8",
            "Authorization": "Token ${sharedPreferences.getString('token')}"
          },
          body: jsonEncode({
            'old_password': oldPass,
            'new_password1': newPass,
            'new_password2': conPass,
          }));
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['detail'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              Constants.snackBar(context, "${responseData['detail']}", true));
        }
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        if (responseData['new_password1'] != null) {
          String output = '';
          for (var element in responseData['new_password1']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        } else if (responseData['new_password2'] != null) {
          String output = '';
          for (var element in responseData['new_password2']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        } else if (responseData['old_password'] != null) {
          String output = '';
          for (var element in responseData['old_password']) {
            output += element + "\n";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.snackBar(context, output, false));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          Constants.snackBar(context, "An error occurred: $e", true));
    }

    return null;
  }
}
