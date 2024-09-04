import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/screens/splashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    navigateToSplash();
  }

  navigateToSplash() async {
    await Future.delayed(Duration(seconds: 3), () {}); // Wait for 2 seconds
    // Navigator.pushReplacementNamed(context, '/splash');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    ); // Navigate to the splash screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ApplicationColors.PURE_WHITE, // Customize the background color
      body: Center(
        // child: CircularProgressIndicator(
        //   color: ApplicationColors.MAIN_COLOR_BLUE,
        //   strokeWidth: 4.0
        // ),

        //  child: SpinKitWave(
        //     color: ApplicationColors.MAIN_COLOR_BLUE,
        //     size: 70.0,
        //     itemCount: 6
        //   )

        child: CupertinoActivityIndicator(
            color: ApplicationColors.MAIN_COLOR_BLUE,
            // strokeWidth: 4.0
            radius: 30.0),
      ),
    );
  }
}
