
import '../routes/app_routes.dart';

  import 'package:flutter/material.dart';
class AuthController {

final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;

    

    // Validasi login sederhana
  if (username == "murid" && password == "123") {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.welcome,
      arguments: {'role': 'murid'},
    );
  } else if (username == "petugas" && password == "123") {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.welcome,
      arguments: {'role': 'petugas'},
    );
  } else {
    // Menampilkan pesan kesalahan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login gagal! Username atau password salah.')),
    );
  }

     // Mengosongkan teks setelah login
    usernameController.clear();
    passwordController.clear();
    
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }



 
}
