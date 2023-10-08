import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/defaultButton.dart';
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
  TextEditingController _fromDate = TextEditingController();
  TextEditingController _toDate = TextEditingController();
  // List<AttendanceReport>? attRepo = [];

  // Future<void> _generateCSV() async {
  //   // List<AttendanceReport>? data = await RemoteService.attendanceReport(
  //   //     context, _fromDate.text, _toDate.text);

  //   List<List<String>> csvData = [
  //     <String>[
  //       'Registration No',
  //       'Full Name',
  //     ],
  //     ...attRepo!.map((item) => [
  //           item.studentId.userId.username,
  //           "${item.studentId.userId.firstName} ${item.studentId.userId.lastName}",
  //         ])
  //   ];
  //   String csv = const ListToCsvConverter().convert(csvData);

  //   // final String dir = (await getExternalStorageDirectory())!.path;
  //   final String dir = (await getDownloadPath(context));
  //   final String path = "$dir/report-${_fromDate.text}to${_toDate.text}.csv";
  //   // print(path);
  //   final File file = File(path);

  //   await file.writeAsString(csv);
  // }

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

  // _submit() async {
  //   var isValid = _form.currentState!.validate();
  //   if (!isValid) return;
  //   _form.currentState!.save();

  //   List<AttendanceReport>? attReport = await RemoteService.attendanceReport(
  //       context, _fromDate.text, _toDate.text);

  //   if (attReport != null && attReport.isNotEmpty) {
  //     // print("Report: $attReport");
  //     setState(() {
  //       attRepo = [];
  //       attRepo = [...attRepo!, ...attReport];
  //     });
  //     // print("Att Report: $attRepo");
  //     showModalBottomSheet(
  //         context: context,
  //         builder: (builder) {
  //           return SizedBox(
  //             height: 500,
  //             width: MediaQuery.of(context).size.width,
  //             child: Padding(
  //               padding: const EdgeInsets.only(top: 20.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.check_circle_outline_rounded,
  //                     size: 150.0,
  //                     color: Constants.primaryColor,
  //                   ),
  //                   const SizedBox(height: 10.0),
  //                   const DefaultText(
  //                       size: 18.0, text: "Successfully Generated"),
  //                   const SizedBox(height: 30.0),
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width * 0.8,
  //                     child: DefaultButton(
  //                         onPressed: () async {
  //                           _generateCSV();
  //                           Navigator.pop(context);
  //                           await Constants.DialogBox(
  //                               context,
  //                               "Report Exported",
  //                               Constants.primaryColor,
  //                               Icons.info_outline_rounded);
  //                           Navigator.pop(context);
  //                         },
  //                         text: "Export",
  //                         textSize: 20.0),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //   } else {
  //     Constants.DialogBox(context, "No attendance on the selected date range",
  //         Constants.primaryColor, Icons.info_outline_rounded);
  //   }
  // }

  pickDate() async {
    var picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));

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
                      ],
                    ),
                  )),
            ),
            const Spacer(),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DefaultButton(
                    onPressed: () {
                      // _submit();
                    },
                    text: 'Generate Report',
                    textSize: 18))
          ],
        ),
      ),
    );
  }
}
