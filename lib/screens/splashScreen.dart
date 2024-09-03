import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/screens/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3), () {});
    // Navigator.pushReplacementNamed(context, '/home');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    ); // Replace with your home screen route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors.PURE_WHITE,
      // backgroundColor: ApplicationColors.MAIN_COLOR_BLUE,
      body: Center(
        child: SvgPicture.asset(
            'assets/images/GUARDROOM_APP_ICON.svg'), // Replace with your image
      ),
    );
  }
}
