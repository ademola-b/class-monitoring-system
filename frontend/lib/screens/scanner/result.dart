import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/models/course_response.dart';
import 'package:frontend/models/student_response.dart';
import 'package:frontend/models/user_details_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/defaultButton.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScannedQR extends StatefulWidget {
  final arguments;

  const ScannedQR(Object? this.arguments, {super.key});

  @override
  State<ScannedQR> createState() => _ScannedQRState();
}

markAttendance(context, String regNo) async {
  // get student id

  StudentResponse? user = await RemoteServices.studentDetail(context, regNo);
  if (user != null) {
    var user_id = user.user!.pk;
  }
  // get lecturer course id
  // CoursesResponse? course = await RemoteServices.

  // send request
}

class _ScannedQRState extends State<ScannedQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const DefaultText(text: "Student Details"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Center(
                child: Column(
              children: [
                DefaultText(text: widget.arguments['code']),
                FutureBuilder(
                    future: RemoteServices.studentDetail(
                        context, widget.arguments['code']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        return Column(
                          children: [
                            ClipOval(
                                child: Image.memory(
                              base64Decode(data!.user!.picMem!),
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            )),
                            const SizedBox(height: 20.0),
                            DefaultText(
                                text: "Student's Name: ${data.user!.name!}",
                                size: 20.0),
                            const SizedBox(height: 10.0),
                            DefaultText(
                                text: "${data.user!.username!}", size: 20.0),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: DefaultButton(
                                  onPressed: () {},
                                  text: "Mark Attendance",
                                  textSize: 18.0),
                            )
                          ],
                        );
                      } else {}
                      return CircularProgressIndicator(
                        color: Constants.splashBackColor,
                      );
                    })
              ],
            )),
          ),
        ));
  }
}
