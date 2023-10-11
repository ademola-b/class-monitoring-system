import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/attendance_report_response.dart';
import 'package:frontend/models/attendance_response.dart';
import 'package:frontend/models/course_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/defaultButton.dart';
import 'package:frontend/utils/defaultDropDown.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:frontend/utils/defaultTextFormField.dart';
import 'package:path_provider/path_provider.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _form = GlobalKey<FormState>();
  DateTime pickedDate = DateTime.now();
  final TextEditingController _fromDate = TextEditingController();
  final TextEditingController _toDate = TextEditingController();
  Map course_list = {};
  late String _course;
  List<AttendanceReportResponse>? attRepo = [];
  var dropdownvalue;
  List<AttendanceReportResponse>? attReport;

  // List<AttendanceReport>? attRepo = [];

  Future<void> _generateCSV() async {
    // List<AttendanceReport>? data = await RemoteService.attendanceReport(
    //     context, _fromDate.text, _toDate.text);

    List<List<String>> csvData = [
      <String>[
        "${attRepo![0].course!.code!} - ${attRepo![0].course!.title!}",
        attRepo![0].date!.toIso8601String(),
      ],
      <String>[
        'Name',
        'Registration No',
      ],
      ...attRepo!.map((item) => [
            item.student!.name!,
            item.student!.username!,
          ])
    ];
    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getDownloadPath(context));
    final String path = "$dir/report-${_fromDate.text}to${_toDate.text}.csv";
    // print(path);
    final File file = File(path);

    await file.writeAsString(csv);
  }

  // get download path
  Future<String> getDownloadPath(context) async {
    Directory? dir;
    try {
      Platform.isIOS
          ? dir = await getApplicationDocumentsDirectory()
          : dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) dir = await getExternalStorageDirectory();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: DefaultText(
              size: 15.0,
              text:
                  "Can't get download folder, check if storage permission is enabled")));
    }

    // print("Saved Dir: ${dir!.path}");
    return dir!.path;
  }

  _submit() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    if (sharedPreferences.getBool("staff")!) {
      attReport = await RemoteServices.attendanceList(
          context, _fromDate.text, _toDate.text,
          course: _course);
    } else {
      attReport = await RemoteServices.attendanceList(
        context,
        _fromDate.text,
        _toDate.text,
      );
    }

    if (attReport != null && attReport!.isNotEmpty) {
      print(attReport);
      setState(() {
        attRepo = [];
        attRepo = [...attRepo!, ...attReport!];
      });
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 150.0,
                      color: Constants.primaryColor,
                    ),
                    const SizedBox(height: 10.0),
                    const DefaultText(
                        size: 18.0, text: "Successfully Generated"),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DefaultButton(
                          onPressed: () async {
                            _generateCSV();
                            Navigator.pop(context);
                            // await Constants.dialogBox(context)
                            await Constants.dialogBox(context,
                                text: "Report Exported",
                                color: Constants.primaryColor,
                                icon: Icons.info_outline_rounded,
                                textColor: Colors.white);
                            Navigator.pop(context);
                          },
                          text: "Export",
                          textSize: 20.0),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      Constants.dialogBox(context,
          text: "No attendance on the provided data",
          color: Constants.primaryColor,
          icon: Icons.info_outline_rounded,
          textColor: Colors.white);
    }
  }

  pickDate() async {
    var picked = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.splashBackColor,
                    onSurface: Constants.pillColor)),
            child: child!);
      },
    );

    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
      });
    }
  }

  pickFromDate() async {
    await pickDate();
    _fromDate.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day}";
  }

  pickToDate() async {
    await pickDate();
    _toDate.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day}";
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
    _getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const DefaultText(
          size: 18,
          text: 'Generate Attendance Report',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DefaultTextFormField(
                            obscureText: false,
                            text: _fromDate,
                            icon: Icons.calendar_today,
                            onTap: pickFromDate,
                            keyboardInputType: TextInputType.none,
                            onSaved: (newVal) {},
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "This field is required";
                              }
                            },
                            label: 'from date',
                            fontSize: 15.0),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                            obscureText: false,
                            text: _toDate,
                            onTap: pickToDate,
                            icon: Icons.calendar_today,
                            keyboardInputType: TextInputType.none,
                            onSaved: (newVal) {},
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "This field is required";
                              }
                            },
                            label: 'to date',
                            fontSize: 15.0),
                        const SizedBox(height: 20.0),
                        sharedPreferences.getBool("staff")!
                            ? DefaultDropDown(
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
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 50.0),
                      ],
                    ),
                  )),
            ),
            const Spacer(),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DefaultButton(
                    onPressed: () {
                      _submit();
                    },
                    text: 'Generate Report',
                    textSize: 18))
          ],
        ),
      ),
    );
  }
}
