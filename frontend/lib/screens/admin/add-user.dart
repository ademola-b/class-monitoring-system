import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/department_response.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/defaultContainer.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultContainer(
                      // text: "Hello, \n ${_username.titleCase()}",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            DefaultText(
                              size: 20.0,
                              align: TextAlign.center,
                              text: "Add Users",
                              color: Constants.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 70.0),
                    DefaultContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/student'),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/student.svg",
                                        width: 100,
                                        height: 100,
                                      ),
                                      const DefaultText(
                                        text: "Add Student",
                                        size: 18.0,
                                        color: Constants.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/lecturer'),
                                  child: Column(
                                    children: [
                                      ClipOval(
                                        child: SvgPicture.asset(
                                          "assets/images/lecturer.svg",
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      const DefaultText(
                                        text: "Add Lecturer",
                                        size: 18.0,
                                        color: Constants.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
