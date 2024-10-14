import 'package:flutter/material.dart';
import '../views/auth/login_page.dart';


class AppRoutes {
  static const String login = '/login';

  static const String welcome = '/welcome';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
   
  };
}
