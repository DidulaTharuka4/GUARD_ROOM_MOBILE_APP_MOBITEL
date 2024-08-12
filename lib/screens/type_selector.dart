import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample_flutter_application_1/components/selector_button.dart';
import 'package:sample_flutter_application_1/constraints/textSizes.dart';
import 'package:sample_flutter_application_1/constraints/token.dart';
import 'package:sample_flutter_application_1/providers/find_all_drivers_provider.dart';
import 'package:sample_flutter_application_1/providers/find_all_vehicles_provider.dart';
// import 'package:sample_flutter_application_1/providers/login_provider.dart';
import 'package:sample_flutter_application_1/screens/daily_attendance.dart';
import 'package:sample_flutter_application_1/screens/daily_trip.dart';
import 'package:sample_flutter_application_1/screens/login.dart';
// import 'package:sample_flutter_application_1/screens/test_page.dart';
import 'package:sample_flutter_application_1/constraints/colors.dart';
import 'package:sample_flutter_application_1/constraints/marginValues.dart';
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
      //Find All
      await Provider.of<FindAllVehiclesProvider>(context, listen: false)
          .findAllVehicles();

      await Provider.of<FindAllDriversProvider>(context, listen: false)
          .findAllDrivers();
    } catch (error) {
      logger.i('Error occurred: $error');
      // print('Error occurred: $error');
    }
  }

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    // final loginProvider = Provider.of<LoginProvider>(context);
    // final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    // final findAllVehiclesProvider = Provider.of<FindAllVehiclesProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ApplicationColors.PURE_WHITE,
        body: Container(
          child: SingleChildScrollView(
            // mainAxisAlignment: MainAxisAlignment.center,
            child: Column(
              children: <Widget>[
                Container(
                    child: Stack(children: <Widget>[
                  Container(
                    width: screenSize.width,
                    height: 110,
                    decoration: BoxDecoration(
                        color: ApplicationColors.PURE_WHITE,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]),
                  ),
                  Container(
                    child: Positioned(
                      bottom: 10.5,
                      right: 20.5,
                      child: PopupMenuButton<String>(
                        color: ApplicationColors.PURE_WHITE,
                        onSelected: (String result) {
                          _onSelected(context, result);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              value: 'Option 1',
                              child: Row(children: [
                                Text('Logout'),
                                SvgPicture.asset(
                                  'logout-box-line',
                                  height: 24,
                                  width: 24,
                                )
                              ])),
                          //   const Container(
                          //     child: Row(
                          // children: [])
                          //   )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 20.5,
                    child: SvgPicture.asset(
                        'assets/images/SLTMobitel_Logo_OnLight.svg',
                        // width: 90.7214,
                        // height: 46.1455,
                        width: screenSize.width / 4.5350,
                        height: screenSize.height / 19.2930),
                  ),
                ])),

                // Page Main title--------------------------------------------
                Container(
                  margin: ApplicationMarginValues.typeSelectorPageTitle,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Main Menu',
                      style: TextStyle(
                          fontSize: ApplicationTextSizes.TypeSelectotPageTitle,
                          fontFamily: 'Poppins',
                          fontWeight:
                              ApplicationTextWeights.PageTitleTextWeight),
                    ),
                  ),
                ),

                // Page sub title-----------------------------------------------
                Container(
                    margin: ApplicationMarginValues.typeSelectorPageSubTitle,
                    child: Column(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Action you need',
                          style: TextStyle(
                            fontSize:
                                ApplicationTextSizes.LoginButtonTitleValue,
                            fontFamily: 'Poppins',
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            // width: 220.0,
                            // height: 2.0,
                            width: screenSize.width / 1.8701,
                            height: screenSize.height / 445.14285,
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

                      // print(
                      //     'Name: ${loginProvider.loginresponse!.loginDetailsDto.mobileNo}\nuser ID: ${loginProvider.loginresponse!.loginDetailsDto.userId}');

                      // print(
                      //     'cname: ${findAllDriversProvider.findAllDriversResponse?.appDriverMobileDtoList[0].cname}');

                      // for (int i = 0; i < findAllDriversProvider.findAllDriversResponse!.appDriverMobileDtoList.length; i++) {
                      //   final driva = findAllDriversProvider.findAllDriversResponse?.appDriverMobileDtoList[i];
                      //   print('${driva?.cname}' + ' - ' + '${driva?.licenseNum}' + ' - ' + '${driva?.nic}' + ' - ' + '${driva?.id}');
                      // }

                      // for (int i = 0; i < findAllVehiclesProvider.findAllVehiclesResponse!.appVehicleMobileDtoList.length; i++) {
                      //   final vehicle = findAllVehiclesProvider.findAllVehiclesResponse?.appVehicleMobileDtoList[i];
                      //   print('${vehicle?.id}' + ' - ' + '${vehicle?.vehicleRegNumber}');
                      // }
                      logger.d("Debug message");
                      logger.i("info message");
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
                        MaterialPageRoute(builder: (context) => DailyTrip()),
                      );

                      loadDriverAndVehicleDetails();
                    },
                  ),
                ),

                // Container(
                //   margin: ApplicationMarginValues.typeSelectorPageSubTitle,
                //   child: TimerScreen()
                // ),

                // Container(
                //   margin: ApplicationMarginValues.typeSelectorPageSubTitle,
                //   child: RealTimeDisplay()
                // ),

                // Container(
                //   margin: ApplicationMarginValues.typeSelectorPageSubTitle,
                //   child: ClockScreen()
                // ),

                // Test Page Button------------------------------------------------
                // Container(
                //   margin: ApplicationMarginValues.typeSelectorPageTitle,
                //   child: CustomButton(
                //     onPress: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => TestPage()),
                //       );
                //     },
                //     innerText: 'Test Page',
                //     backgroundColor: ApplicationColors.PURE_WHITE,
                //     borderRadius: 10,
                //     buttonWidth: screenSize.width / 2.057,
                //     buttonHeight: screenSize.height / 11.1288,
                //     textStyles: TextStyle(
                //       fontSize: ApplicationTextSizes.attendancePageButtonTitle,
                //       fontWeight: FontWeight.bold,
                //       color: ApplicationColors.PURE_BLACK,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
