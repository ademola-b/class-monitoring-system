import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/screens/admin/sidebar.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/dateContainer.dart';
import 'package:frontend/utils/defaultContainer.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:frontend/utils/string_extension.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  DateTime date = DateTime.now();
  Timer? timer;
  double? indicatorValue;

  final String _username = 'Username';

  // updateSeconds() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //     setState(() {
  //       indicatorValue = DateTime.now().second / 60;
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateSeconds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.backgroundColor,
      drawer: Sidebar(),
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
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
                ],
              ),
            )),
      ),
    ));
  }
}
