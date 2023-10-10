import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:qr_flutter/qr_flutter.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  Map level = {
    'ND I': 'ND I',
    'ND II': 'ND II',
    'HND I': 'HND I',
    'HND II': 'HND II'
  };
  Map dept_list = {};
  String? fileSelect = 'No file selected';
  bool _isDisabled = true;
  bool _isLoading = false;
  List<Map<String, dynamic>> listOfMap = [{}];

  final _form = GlobalKey<FormState>();
  late String _name;
  late String _regNo;
  late String _level;
  late String _dept;
  String? examOfficerDept;
  String? filePath;
  TextEditingController name = TextEditingController();
  TextEditingController regNo = TextEditingController();

  generateQrCode() {
    QrImage(
      data: _regNo,
      size: 150,
      version: QrVersions.auto,
    );
  }

  void _addStudent() async {
    var _isValid = _form.currentState!.validate();
    if (!_isValid) return;
    _form.currentState!.save();

    await RemoteServices.createStudent(context, data: [
      {
        "user": {
          "name": _name,
          "username": _regNo,
          "is_staff": false,
          "is_student": true,
          "is_lecturer": false
        },
        "department": _dept,
        "level": _level
      }
    ]);

    await RemoteServices.saveQrImage(context, _regNo);

    _reset();
    // Navigator.pop(context);
  }

  void _reset() async {
    name = TextEditingController(text: '');
    regNo = TextEditingController(text: '');
  }

  _getDepts() async {
    List<DepartmentResponse?>? depts =
        await RemoteServices.departments(context);
    if (depts!.isNotEmpty) {
      setState(() {
        for (var dept in depts) {
          dept_list[dept!.deptId] = dept.deptName;
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
    _getDepts();
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
                      text: "Add Student",
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
                            _dept = newVal;
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
                          dropdownMenuItemList: dept_list
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
                          text: "Department",
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onSaved: (newVal) {
                            _level = newVal;
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
                          dropdownMenuItemList: level
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
                          text: "Level",
                        ),
                        const SizedBox(height: 50.0),
                        SizedBox(
                          width: size.width,
                          child: DefaultButton(
                              onPressed: () async {
                                // await generateQrCode();
                                _addStudent();
                                
                              },
                              text: "Add Student",
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
