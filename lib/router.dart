import 'package:flutter/material.dart';
import 'package:race_timing_app/pages/home.dart';
import 'package:race_timing_app/pages/login.dart';

const HomePageRoute = '/';
const LoginPageRoute = '/login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePageRoute:
        return MaterialPageRoute(
            builder: (context) => Home()
        );
      case LoginPageRoute:
        return MaterialPageRoute(
            builder: (context) => Login()
        );
      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}