import 'package:flutter/material.dart';
import 'package:frontend/change_password.dart';
import 'package:frontend/screens/admin/add-user.dart';
import 'package:frontend/screens/admin/adminNavbar.dart';
import 'package:frontend/screens/admin/dashboard.dart';
import 'package:frontend/screens/admin/lecturer.dart';
import 'package:frontend/screens/admin/student.dart';
import 'package:frontend/screens/lecturer/bottomNavbar.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/scan.dart';
import 'package:frontend/screens/scanner/qr_scanner.dart';
import 'package:frontend/screens/scanner/result.dart';
import 'package:frontend/screens/splash.dart';
import 'package:frontend/screens/studentNavbar.dart';
import 'package:frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(MaterialApp(
    theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Constants.backgroundColor, elevation: 0.0)),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: getRoutes,
  ));
}

Route<dynamic> getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _buildRoute(settings, const SplashScreen());

    case '/login':
      return _buildRoute(settings, const Login());

    case '/admin-dashboard':
      return _buildRoute(settings, const AdminDashboard());

    case '/studentNavbar':
      return _buildRoute(settings, const StudentNavbar());

    case '/adminNavbar':
      return _buildRoute(settings, const AdminNavbar());

    case '/lecturerNavbar':
      return _buildRoute(settings, const LecturerNavbar());

    case '/student':
      return _buildRoute(settings, const Student());

    case '/lecturer':
      return _buildRoute(settings, const Lecturer());

    case '/scan':
      return _buildRoute(settings, const Scan());

    case '/result':
      return _buildRoute(settings, ScannedQR(settings.arguments));

    case '/addUser':
      return _buildRoute(settings, const AddUser());

    case '/changePassword':
      return _buildRoute(settings, const ChangePassword());

    default:
      return _buildRoute(settings, const SplashScreen());
  }
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(settings: settings, builder: ((context) => builder));
}
