import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_details_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/dateContainer.dart';
import 'package:frontend/utils/defaultButton.dart';
import 'package:frontend/utils/defaultContainer.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:frontend/utils/string_extension.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime date = DateTime.now();
  Timer? timer;
  double? indicatorValue;

  String _username = 'Username';

  updateSeconds() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          indicatorValue = DateTime.now().second / 60;
        });
      }
    });
  }

  _getUser() async {
    UserDetailsResponse? user = await RemoteServices.userDetails(context);
    setState(() {
      _username = user!.username!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateSeconds();
    _getUser();
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: DefaultButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/scan');
                        },
                        text: "SCAN",
                        textSize: 18.0),
                  ),
                ],
              ),
            )),
      ),
    ));
  }
}
