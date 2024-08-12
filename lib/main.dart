import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_application_1/notifiers/mileage_unit.dart';
import 'package:sample_flutter_application_1/providers/end_attendance_provider.dart';
import 'package:sample_flutter_application_1/providers/find_all_vehicles_provider.dart';
import 'package:sample_flutter_application_1/providers/find_all_drivers_provider.dart';
import 'package:sample_flutter_application_1/providers/login_provider.dart';
import 'package:sample_flutter_application_1/providers/start_attendance_provider.dart';
import 'package:sample_flutter_application_1/providers/vehicle_in_provider.dart';
import 'package:sample_flutter_application_1/providers/vehicle_out_provider.dart';

import 'screens/login.dart';

// void main() => runApp(MyApp());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: LoginPage(),
      // home: TypeSelector(),
    );
  }
}
