import 'package:flutter/material.dart';
import '/views/home/welcome_page.dart';
import '/views/auth/login_page.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const SchoolApp());
}

class SchoolApp extends StatelessWidget {
  const SchoolApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login, // Menggunakan rute login sebagai rute awal
     routes: {
       AppRoutes.login: (context) => LoginPage(),
        AppRoutes.welcome: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return WelcomePage(role: args['role']);
        },
      },  // Menggunakan map rute dari AppRoutes
      debugShowCheckedModeBanner: false,
    );
  }
}
