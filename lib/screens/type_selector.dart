import 'package:Guard_Room_Application/components/buttons/type_selector_button.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/screens/daily_attendance.dart';
import 'package:Guard_Room_Application/screens/daily_trip.dart';
import 'package:Guard_Room_Application/screens/login.dart';
import 'package:Guard_Room_Application/components/app_bars/selector_page_appbr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class TypeSelector extends StatefulWidget {
  @override
  _TypeSelector createState() => _TypeSelector();
}

class _TypeSelector extends State<TypeSelector> {
  void _onSelected(BuildContext context, String value) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('token cleared and go to login page !'),
    //   ),
    // );
    clearToken();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void loadDriverAndVehicleDetails() async {
    try {
      await Provider.of<FindAllVehiclesProvider>(context, listen: false)
          .findAllVehicles();

      await Provider.of<FindAllDriversProvider>(context, listen: false)
          .findAllDrivers();
    } catch (error) {
      logger.i('Error occurred: $error');
    }
  }

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    // final loginProvider = Provider.of<LoginProvider>(context);
    // final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    // final findAllVehiclesProvider = Provider.of<FindAllVehiclesProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          // Exit the app when the back button is pressed
          SystemNavigator.pop();
          return false; // Returning false prevents the usual behavior
        },
        child: Scaffold(
            backgroundColor: ApplicationColors.PURE_WHITE,
            appBar: const SelectorPageAppBarWithShadow(),
            body: Container(
              child: SingleChildScrollView(
                // mainAxisAlignment: MainAxisAlignment.center,
                child: Column(
                  children: <Widget>[
                    // Page Main title--------------------------------------------
                    Container(
                      margin: ApplicationMarginValues.typeSelectorPageTitle,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Main Menu',
                          style: TextStyle(
                              fontSize:
                                  ApplicationTextSizes.TypeSelectotPageTitle(context),
                              fontFamily: 'Poppins',
                              fontWeight:
                                  ApplicationTextWeights.PageTitleTextWeight),
                        ),
                      ),
                    ),

                    // Page sub title-----------------------------------------------
                    Container(
                        margin:
                            ApplicationMarginValues.typeSelectorPageSubTitle,
                        child: Column(children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Select Action you need',
                              style: TextStyle(
                                fontSize:
                                    ApplicationTextSizes.LoginButtonTitleValue(context),
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                // width: 220.0,
                                // height: 2.0,
                                width: screenSize.width / 1.88,
                                height: screenSize.height / 445.14,
                                child: Container(
                                  color: ApplicationColors.LINE_GREEN,
                                ),
                              ))
                        ])),

                    // Attendance Button------------------------------------------
                    Container(
                      margin: ApplicationMarginValues.loginPageButtonMargin,
                      // color: Colors.red,
                      child: SelectorButton(
                        innerText: 'ATTENDANCE',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DailyAttendance()),
                          );
                          loadDriverAndVehicleDetails();
                        },
                      ),
                    ),

                    // Trips Button------------------------------------------------
                    Container(
                      margin: ApplicationMarginValues.typeSelectorPageSubTitle,
                      child: SelectorButton(
                        innerText: 'TRIPS',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DailyTrip()),
                          );
                          loadDriverAndVehicleDetails();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
