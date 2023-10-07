import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/screens/dashboard.dart';
import 'package:frontend/screens/more.dart';
import 'package:frontend/screens/report.dart';
import 'package:frontend/utils/constants.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: IndexedStack(
        index: currentPage,
        children: const [Dashboard(), ReportForm(), More()],
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Constants.backgroundColor,
        activeIconColor: Constants.splashBackColor,
        inactiveIconColor: Constants.backgroundColor,
        barBackgroundColor: Constants.splashBackColor,
        textColor: Constants.backgroundColor,
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
          ),
          TabData(
            iconData: Icons.report,
            title: "Report",
          ),
          TabData(
            iconData: Icons.more,
            title: "More",
          ),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (int position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}
