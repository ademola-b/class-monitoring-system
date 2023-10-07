import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/constants.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // UserDetailsResponse? user;
  var check_login = 0;

  // get the nextscreen
  // to be modified to return widget
  nextScreen(context) async {
    String? token = sharedPreferences.getString('token');
    // if (token != null) {
    //   UserDetailsResponse? user = await RemoteServices.userResponse(context);
    //   if (user != null) {
    //     if (user.isExamofficer) {
    //       setState(() {
    //         check_login = 1;
    //       });
    //     } else if (user.isInvigilator || user.isStudent) {
    //       setState(() {
    //         check_login = 2;
    //       });
    //     } else {
    //       setState(() {
    //         check_login = 0;
    //       });

    //     }
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(Constants.snackBar(context, "Invalid User", false));
    //   }
    // }

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset("assets/images/checked_user.svg",
                    width: 250, height: 250),
              )
            ],
          ),
        ),
        backgroundColor: Constants.backgroundColor,
        splashIconSize: 300.0,
        nextScreen: const Login());
  }
}
