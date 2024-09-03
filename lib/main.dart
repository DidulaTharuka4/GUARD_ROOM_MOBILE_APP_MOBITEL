import 'package:Guard_Room_Application/notifiers/mileage_unit.dart';
import 'package:Guard_Room_Application/providers/end_attendance_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/providers/start_attendance_provider.dart';
import 'package:Guard_Room_Application/providers/vehicle_in_provider.dart';
import 'package:Guard_Room_Application/providers/vehicle_out_provider.dart';
import 'package:Guard_Room_Application/screens/loadingScreen.dart';
import 'package:Guard_Room_Application/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:sample_flutter_application_1/notifiers/mileage_unit.dart';
// import 'package:sample_flutter_application_1/providers/end_attendance_provider.dart';
// import 'package:sample_flutter_application_1/providers/find_all_vehicles_provider.dart';
// import 'package:sample_flutter_application_1/providers/find_all_drivers_provider.dart';
// import 'package:sample_flutter_application_1/providers/login_provider.dart';
// import 'package:sample_flutter_application_1/providers/start_attendance_provider.dart';
// import 'package:sample_flutter_application_1/providers/vehicle_in_provider.dart';
// import 'package:sample_flutter_application_1/providers/vehicle_out_provider.dart';

import 'screens/login.dart';

import 'package:logger/logger.dart';

// void main() => runApp(MyApp());

void main() async {
  // var logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 0));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Adjust icon color
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // For landscape mode, use the following instead:
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]).then((_) {
    // runApp(MyApp());

    // runApp(
    //   ChangeNotifierProvider(
    //     create: (context) => MileageUnit(),
    //     child: MyApp(),
    //   ),
    // );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MileageUnit()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => StartAttendanceProvider()),
          ChangeNotifierProvider(create: (_) => EndAttendanceProvider()),
          ChangeNotifierProvider(create: (_) => VehicleInProvider()),
          ChangeNotifierProvider(create: (_) => VehicleOutProvider()),
          ChangeNotifierProvider(create: (_) => FindAllVehiclesProvider()),
          ChangeNotifierProvider(create: (_) => FindAllDriversProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => LoadingScreen(),
        '/home': (context) => SplashScreen(), // Replace with your home screen
      },

      // home: LoginPage(),
      // home: TypeSelector(),
    );
  }
}
