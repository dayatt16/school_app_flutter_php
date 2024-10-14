// views/home/welcome_page.dart
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'home_page_admin.dart';
import 'gallery_page_admin.dart';
import 'information_page_admin.dart';
import 'agenda_page_admin.dart';

import 'home_page.dart';
import 'gallery_page.dart';
import 'information_page.dart';
import 'agenda_page.dart';

class WelcomePage extends StatefulWidget {
  final String role; // Menambahkan parameter role
  const WelcomePage({Key? key, required this.role}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    if (widget.role == "murid") {
      // Tampilan untuk murid
      return [
      HomePage(),
        InformationPage(),
        AgendasPage(),
        GalleriesPage(),
      ];
    } else if (widget.role == "petugas") {
      // Tampilan untuk petugas
      return [
        HomePageAdmin(),
        InformationPageAdmin(),
        AgendasPageAdmin(),
        GalleriesPageAdmin(),
        // Tambahkan halaman tambahan jika diperlukan
      ];
    } else {
      // Default, jika peran tidak dikenali
      return [
        HomePage(),
        InformationPage(),
        AgendasPage(),
        GalleriesPage(),
      ];
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_filled),
        title: ("Home"),
        activeColorPrimary:  Color.fromARGB(255, 22, 113, 205),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.info_outline),
        title: ("Informasi"),
        activeColorPrimary:  Color.fromARGB(255, 22, 113, 205),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: ("Agenda"),
        activeColorPrimary:  Color.fromARGB(255, 22, 113, 205),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.photo_library),
        title: ("Galeri"),
        activeColorPrimary:  Color.fromARGB(255, 22, 113, 205),
        inactiveColorPrimary: Colors.grey,
      ),
      // Jika petugas memiliki tab tambahan, tambahkan di sini
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        animationSettings: NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
          ),
        ),
        navBarStyle: NavBarStyle.style3, // Mengubah dari style7 ke style3
      ),
    );
  }
}
