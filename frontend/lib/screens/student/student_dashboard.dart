import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/models/student_qr_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/dateContainer.dart';
import 'package:frontend/utils/defaultButton.dart';
import 'package:frontend/utils/defaultContainer.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:frontend/utils/string_extension.dart';
import 'package:intl/intl.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  DateTime date = DateTime.now();
  Timer? timer;
  double? indicatorValue;
  List<StudentQrResponse>? stdQr;

  final String _username = 'Username';

  updateSeconds() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        indicatorValue = DateTime.now().second / 60;
      });
    });
  }

  getQrImage() async {
    List<StudentQrResponse>? _studentQr =
        await RemoteServices.studentQr(context);
    if (_studentQr!.isNotEmpty) {
      print("hello");
      setState(() {
        stdQr = _studentQr;
        print(_studentQr[0].qrMem);
      });
    } else {}

    print(stdQr);
  }

  @override
  void initState() {
    getQrImage();
    // TODO: implement initState
    super.initState();
    updateSeconds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DefaultContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultText(
                            size: 20.0,
                            text: "Hello, \n ${_username.toTitleCase()}",
                            // text: "Hello, \n ${username!.titleCase()}",
                            color: Constants.primaryColor,
                          ),
                          const Spacer(),
                          DefaultText(
                            size: 25,
                            text: time(),
                            color: Constants.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DateContainer(day: "${date.day}"),
                      DateContainer(day: DateFormat.MMMM().format(date)),
                      DateContainer(day: "${date.year}"),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Image.memory(stdQr![0].qrMem!),

                  // FutureBuilder(
                  //     future: RemoteServices.studentQr(context),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData && snapshot.data!.isEmpty) {
                  //         return SizedBox(
                  //           child: DefaultText(
                  //             text: "No QrCode Found, kindly contact the admin",
                  //             size: 18.0,
                  //             color: Constants.pillColor,
                  //             align: TextAlign.center,
                  //           ),
                  //         );
                  //       } else if (snapshot.hasData) {
                  //         var data = snapshot.data![0];
                  //         return Image.memory(data.qrMem!);
                  //       }
                  //       return const CircularProgressIndicator();
                  //     })
                  // // QR Code to be displayed here
                ],
              ),
            )),
      ),
    ));
  }
}
