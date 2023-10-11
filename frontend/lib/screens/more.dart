import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/services/remote_services.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/utils/defaultText.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  String? userType;
  List stdCourse = [];

  var profile_pic;

  final List<String> _labels = [
    // "Personal Information",
    "Change Password",
  ];

  final List<IconData> _labelIcons = [
    // Icons.person,
    Icons.lock,
  ];

  final List<String> _labelRoutes = ['/changePassword'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Constants.backgroundColor,
            body: Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, right: 20.0, left: 20.0, bottom: 40.0),
              child: Column(children: [
                Center(
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: RemoteServices.fullUserDetails(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                    height: 150.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      border: Border.all(
                                          color: Constants.splashBackColor,
                                          width: 4.0),
                                      image: DecorationImage(
                                        image: MemoryImage(base64Decode(
                                            snapshot.data!.picMem!)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  DefaultText(
                                    text: snapshot.data!.name!,
                                    size: 20.0,
                                    color: Constants.splashBackColor,
                                  ),
                                  const SizedBox(height: 10.0),
                                  DefaultText(
                                      text: snapshot.data!.username!,
                                      color: Constants.splashBackColor,
                                      size: 20.0),
                                  const SizedBox(height: 10.0),
                                ],
                              );
                            } else {
                              return const DefaultText(
                                  text: "Can't get user profile ", size: 15.0);
                            }
                            // return const CircularProgressIndicator();
                          }),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _labels.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Constants.splashBackColor,
                            border: Border.all(
                                color: Constants.splashBackColor, width: 0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: ListTile(
                            textColor: Constants.splashBackColor,
                            leading: Icon(
                              _labelIcons[index],
                              color: Constants.backgroundColor,
                            ),
                            title: DefaultText(
                              text: _labels[index],
                              size: 18.0,
                              color: Constants.primaryColor,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.primaryColor,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, _labelRoutes[index]);
                            },
                          ),
                        );
                      }),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ListTile(
                    textColor: Colors.red,
                    leading: Icon(
                      Icons.logout,
                      color: Constants.pillColor,
                    ),
                    title: DefaultText(
                      size: 15.0,
                      text: "Logout",
                      color: Constants.splashBackColor,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Constants.primaryColor,
                    ),
                    onTap: () async {
                      sharedPreferences.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ),
              ]),
            )));
  }
}
