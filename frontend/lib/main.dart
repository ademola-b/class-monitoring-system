import 'package:flutter/material.dart';
import 'package:frontend/screens/bottomNavbar.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/scan.dart';
import 'package:frontend/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: getRoutes,
  ));
}

Route<dynamic> getRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _buildRoute(settings, const SplashScreen());

    case '/navbar':
      return _buildRoute(settings, const Navbar());
    case '/scan':
      return _buildRoute(settings, ScanQrPage());

    default:
      return _buildRoute(settings, const SplashScreen());
  }
}

MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(settings: settings, builder: ((context) => builder));
}
