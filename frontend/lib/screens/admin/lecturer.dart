import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/models/course_response.dart';
import 'package:frontend/models/department_response.dart';
import 'package:frontend/models/user_details_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/defaultButton.dart';
import 'package:frontend/utils/defaultContainer.dart';
import 'package:frontend/utils/defaultDropDown.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:frontend/utils/defaultTextFormField.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class Lecturer extends StatefulWidget {
  const Lecturer({super.key});

  @override
  State<Lecturer> createState() => _LecturerState();
}

class _LecturerState extends State<Lecturer> {
  Map course_list = {};
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  bool _isLoading = false;
  List<Map<String, dynamic>> listOfMap = [{}];

  final _form = GlobalKey<FormState>();
  late String _name;
  late String _regNo;
  late String _course;
  String? examOfficerDept;
  String? filePath;
  TextEditingController name = TextEditingController();
  TextEditingController regNo = TextEditingController();

  
  void _addLecturer() async {
    var _isValid = _form.currentState!.validate();
    if (!_isValid) return;
    _form.currentState!.save();

    await RemoteServices.createLecturer(context, data: [
      {
        "user": {
          "name": _name,
          "username": _regNo,
          "is_staff": false,
          "is_student": false,
          "is_lecturer": true
        },
        "course": _course
      }
    ]);

    _reset();
    Navigator.pop(context);
  }

  void _reset() async {
    name = TextEditingController(text: '');
    regNo = TextEditingController(text: '');
  }

  _getCourses() async {
    List<CoursesResponse?>? courses = await RemoteServices.courses(context);
    if (courses!.isNotEmpty) {
      setState(() {
        for (var course in courses) {
          course_list[course!.courseId] = course.title;
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(Constants.snackBar(context, "No Course", false));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getUser();
    _getCourses();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var dropdownvalue;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.splashBackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.backgroundColor),
                      iconSize: 25,
                    ),
                    const DefaultText(
                      text: "Add Lecturer",
                      size: 20.0,
                      color: Constants.primaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 50.0),
                
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          text: name,
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Name",
                          fillColor: Colors.white,
                          onSaved: (value) {
                            _name = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Registration No",
                          fillColor: Colors.white,
                          onSaved: (value) {
                            _regNo = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onSaved: (newVal) {
                            _course = newVal;
                          },
                          validator: (value) {
                            if (value == null) return "field is required";
                            return null;
                          },
                          value: dropdownvalue,
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal!;
                            });
                          },
                          dropdownMenuItemList: course_list
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                      value: key,
                                      child: DefaultText(
                                        text: value.toString(),
                                        color: Constants.primaryColor,
                                      ))))
                              .values
                              .toList(),
                          text: "Course",
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () {
                                _addLecturer();
                              },
                              text: "Add Lecturer",
                              textSize: 20.0),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
