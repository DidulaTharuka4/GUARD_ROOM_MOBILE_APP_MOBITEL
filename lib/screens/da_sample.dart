import 'dart:async';
import 'package:Guard_Room_Application/components/invalid_input_alert_box.dart';
import 'package:Guard_Room_Application/components/confirmation_alert_box.dart';
import 'package:Guard_Room_Application/components/main_button.dart';
import 'package:Guard_Room_Application/components/custom_selector_button.dart';
import 'package:Guard_Room_Application/components/main_text_input.dart';
import 'package:Guard_Room_Application/components/toggle_button.dart';
import 'package:Guard_Room_Application/components/success_error_alert_box.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/notifiers/mileage_unit.dart';
import 'package:Guard_Room_Application/providers/end_attendance_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/providers/start_attendance_provider.dart';
import 'package:Guard_Room_Application/screens/type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyAttendance extends StatefulWidget {
  @override
  _DailyAttendance createState() => _DailyAttendance();
}

class _DailyAttendance extends State<DailyAttendance> {
  final TextEditingController _currentDateController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _driverLicenseController =
      TextEditingController();
  final TextEditingController _replaceDriverNICController =
      TextEditingController();
  final TextEditingController _replaceCommentController =
      TextEditingController();
  final TextEditingController _replaceVehicleNumberController =
      TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _currentMileageController =
      TextEditingController();

  var logger = Logger();
  final loginProvider = Provider.of<LoginProvider>;
  final findAllVehiclesProvider = Provider.of<FindAllVehiclesProvider>;
  final findAllDriversProvider = Provider.of<FindAllDriversProvider>;
  final startAttendanceProvider = Provider.of<StartAttendanceProvider>;
  final endAttendanceProvider = Provider.of<EndAttendanceProvider>;

  bool toggleValue1 = false;
  double? finalMileageValue;
  String mileageUnit = 'km';
  int? vehicleID;
  int? driverID;
  int? userID;
  String? userName;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  late Timer timer;

  String? _vehicleNumberError;
  String? _licenseNumberError;
  // String? _driverNameError;
  String? _currentMileageError;
  String? combinedDateTime;
  String? driverName;
  String? finalResponseStatus;

  bool isAllFilled = false;
  bool isRequiredFilled = false;
  bool isVehicleValId = false;
  bool isDriverId = false;

  bool requiredVehicleNumberFilled = false;
  bool requiredDriverDetailFilled = false;

  bool? successStatusStartWithoutTemp;
  bool? successStatusStartWithTemp;
  bool? successStatusEndWithoutTemp;
  bool? successStatusEndWithTemp;
  bool? successStatus;

  bool showDropdown = false;
  FocusNode focusNodeForExpandableList = FocusNode();

  bool showLicenseNumberDropdown = false;
  FocusNode focusNodeForLicenseNumberExpandableList = FocusNode();

  @override
  void initState() {
    super.initState();
    startClock();
    getCurrentDate();

    focusNodeForExpandableList.addListener(() {
      if (!focusNodeForExpandableList.hasFocus) {
        setState(() {
          showDropdown = false;
        });
      }
    });

    focusNodeForLicenseNumberExpandableList.addListener(() {
      if (!focusNodeForLicenseNumberExpandableList.hasFocus) {
        setState(() {
          showLicenseNumberDropdown = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _timeController.dispose();
    super.dispose();
  }

  String getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // real time updating clock and timer function------------------------------
  void startClock() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeController.text = getCurrentTime();
      _dateTimeController.text =
          "${_dateController.text} ${_timeController.text}";
    });
  }

  // real time updating date function------------------------------
  void getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateController.text = formattedDate;
    print(formattedDate);
  }

  // Invalid field error message
  void invalidFieldAlertDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(),
        );
      },
    );
  }

  // Required field empty error message
  void emptyRequiredFieldsAlertDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(),
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            // child: CircularProgressIndicator(
            //     color: ApplicationColors.MAIN_COLOR_BLUE, strokeWidth: 4.0),

            child: CupertinoActivityIndicator(
                color: ApplicationColors.MAIN_COLOR_BLUE, radius: 30.0),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the loading dialog
  }

  //  Check all field empty or not
  void checkFIlledAllFields() {
    setState(() {
      _currentMileageError = _currentMileageController.text.isEmpty
          ? 'Mileage cannot be empty'
          : null;
    });

    isAllFilled = true;
  }

  // Check required field empty or not
  void checkFilledRequiredFields() {
    setState(() {
      _vehicleNumberError = _vehicleNumberController.text.isEmpty
          ? 'Vehicle Number cannot be empty'
          : null;
      _licenseNumberError = _driverLicenseController.text.isEmpty
          ? 'License Number cannot be empty'
          : null;
      _currentMileageError = _currentMileageController.text.isEmpty
          ? 'Mileage cannot be empty'
          : null;
      // _driverNameError =
      _driverNameController.text.isEmpty ? 'Name cannot be empty' : null;
    });

    if (_vehicleNumberController.text.isEmpty == false ||
        _replaceVehicleNumberController.text.isEmpty == false) {
      requiredVehicleNumberFilled = true;
      print('vehicle number okay');
    } else {
      requiredVehicleNumberFilled = false;
      print('vehicle number not okay');
    }

    if (_driverLicenseController.text.isEmpty == false ||
        _replaceDriverNICController.text.isEmpty == false) {
      requiredDriverDetailFilled = true;
      print('driver details okay');
    } else {
      requiredDriverDetailFilled = false;
      print('driver details not okay');
    }

    if (requiredVehicleNumberFilled == true &&
        requiredDriverDetailFilled == true &&
        _currentMileageController.text.isEmpty == false) {
      isRequiredFilled = true;
    } else {
      isRequiredFilled = false;
    }
  }

  // Work in button function
  void workInButton() {
    logger.i('work in inside');
    setState(() {
      combinedDateTime = '${_dateController.text} ${_timeController.text}';
    });

    if (isRequiredFilled == true && isAllFilled == true) {
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i(vehicleID);
        logger.i(driverID);
        logger.i('invalid driver license number !');
      } else {
        logger.i('all are okay');
        logger.i('Vehicle ID - ${vehicleID}');
        workInButtonDialogBox(context);
      }
    } else if (isRequiredFilled == false && isAllFilled == true) {
      logger.i('errors with required fields');

      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == true && isAllFilled == false) {
      logger.i('errors with all fields');

      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == false && isAllFilled == false) {
      logger.i('errors with required and all inputs');
      invalidFieldAlertDialogBox(context);
      getCurrentDate();
      logger.i(combinedDateTime);
    }
  }

  // work out button function
  void workOutButton() {
    setState(() {
      combinedDateTime =
          '${_dateController.text}' + ' ' + '${_timeController.text}';
    });
    // print('now in work out button');

    if (isRequiredFilled == true && isAllFilled == true) {
      logger.i('input validations success');
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        logger.i('all are okay');
        workOutButtonDialogBox(context);
      }
    } else if (isRequiredFilled == false && isAllFilled == true) {
      logger.i('errors with required fields');
      emptyRequiredFieldsAlertDialogBox(context);
    } else if (isRequiredFilled == true && isAllFilled == false) {
      logger.i('errors with all fields');
      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == false && isAllFilled == false) {
      logger.i('errors with required and all inputsy');
      invalidFieldAlertDialogBox(context);
      getCurrentDate();
    }
  }

  // Work in button yes command
  void workInButtonDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBoxSelector(
              pressForYesButton: () {
                startWithWithoutSelector();
                Navigator.of(context).pop();
              },
              alertDialogText:
                  'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text} ${_replaceVehicleNumberController.text}:  ?'),
        );
      },
    );
  }

  // Work out button yes command
  void workOutButtonDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBoxSelector(
              pressForYesButton: () {
                endWithWithoutSelector();
                Navigator.of(context).pop();
              },
              alertDialogText:
                  'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text}:  ?'),
        );
      },
    );
  }

  // with temp or without temp selector functions-----------------
  void startWithWithoutSelector() {
    if (_replaceDriverNICController.text.isEmpty == true &&
        _replaceVehicleNumberController.text.isEmpty == true) {
      startAttendanceWithoutTempFunc();
    } else {
      startAttendanceWithTempFunc();
    }
  }

  void endWithWithoutSelector() {
    if (_replaceDriverNICController.text.isEmpty == true &&
        _replaceVehicleNumberController.text.isEmpty == true) {
      endAttendanceWithoutTempFunc();
    } else {
      endAttendanceWithTempFunc();
    }
  }

  // Functions to pass data to providers-------------------------------
  void startAttendanceWithTempFunc() async {
    Map<String, dynamic> vehicleAttendanceDto = {};

    vehicleAttendanceDto['vehicleId'] = vehicleID;
    vehicleAttendanceDto['driverId'] = driverID;
    vehicleAttendanceDto['tempVehicleNo'] =
        _replaceVehicleNumberController.text;
    vehicleAttendanceDto['tempDriverNic'] = _replaceDriverNICController.text;
    vehicleAttendanceDto['gateStartTime'] = combinedDateTime;
    vehicleAttendanceDto['addedBy'] = userID;
    vehicleAttendanceDto['startComment'] = _replaceCommentController.text;
    vehicleAttendanceDto['startOfficer'] = userName;
    vehicleAttendanceDto['startMileage'] = _currentMileageController.text;

    Map<String, dynamic> startWithTempRequestBody = {
      'vehicleAttendanceDto': vehicleAttendanceDto
    };

    try {
      await Provider.of<StartAttendanceProvider>(context, listen: false)
          .startAttendanceWithTemp(startWithTempRequestBody);
    } catch (error) {
      logger.i('Error occurred in startAttendanceWithTempFunc: $error');
    }
    logger.i('e1');

    showLoadingDialog(context);
    await Future.delayed(Duration(seconds: 2));
    hideLoadingDialog(context);

    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void startAttendanceWithoutTempFunc() async {
    Map<String, dynamic> vehicleAttendanceDto = {};

    vehicleAttendanceDto['vehicleId'] = vehicleID;
    vehicleAttendanceDto['driverId'] = driverID;
    vehicleAttendanceDto['gateStartTime'] = combinedDateTime;
    vehicleAttendanceDto['addedBy'] = userID;
    vehicleAttendanceDto['startComment'] = 'Start Comment';
    vehicleAttendanceDto['startOfficer'] = userName;
    vehicleAttendanceDto['startMileage'] = _currentMileageController.text;

    Map<String, dynamic> startWithoutTempRequestBody = {
      'vehicleAttendanceDto': vehicleAttendanceDto
    };

    try {
      await Provider.of<StartAttendanceProvider>(context, listen: false)
          .startAttendanceWithoutTemp(startWithoutTempRequestBody);
    } catch (error) {
      logger.i('Error occurred 67: $error');
    }
    logger.i('e2');

    showLoadingDialog(context);
    await Future.delayed(Duration(seconds: 2));
    hideLoadingDialog(context);

    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void endAttendanceWithTempFunc() async {
    Map<String, dynamic> vehicleAttendanceDto = {};

    vehicleAttendanceDto['vehicleId'] = vehicleID;
    vehicleAttendanceDto['driverId'] = driverID;
    vehicleAttendanceDto['tempVehicleNo'] =
        _replaceVehicleNumberController.text;
    vehicleAttendanceDto['tempDriverNic'] = _replaceDriverNICController.text;
    vehicleAttendanceDto['gateEndTime'] = combinedDateTime;
    vehicleAttendanceDto['endComment'] = _replaceCommentController.text;
    vehicleAttendanceDto['endOfficer'] = userName;
    vehicleAttendanceDto['endMileage'] = _currentMileageController.text;

    Map<String, dynamic> endWithTempRequestBody = {
      'vehicleAttendanceDto': vehicleAttendanceDto
    };
    try {
      await Provider.of<EndAttendanceProvider>(context, listen: false)
          .EndAttendanceWithTemp(endWithTempRequestBody);

      // successCall();
    } catch (error) {
      logger.i('Error occurred 67: $error');
    }

    logger.i('e3');

    showLoadingDialog(context);
    await Future.delayed(Duration(seconds: 2));
    hideLoadingDialog(context);

    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void endAttendanceWithoutTempFunc() async {
    Map<String, dynamic> vehicleAttendanceDto = {};

    vehicleAttendanceDto['vehicleId'] = vehicleID;
    vehicleAttendanceDto['driverId'] = driverID;
    vehicleAttendanceDto['gateEndTime'] = combinedDateTime;
    vehicleAttendanceDto['endComment'] = 'End comments';
    vehicleAttendanceDto['endOfficer'] = userName;
    vehicleAttendanceDto['endMileage'] = _currentMileageController.text;

    Map<String, dynamic> endWithoutTempRequestBody = {
      'vehicleAttendanceDto': vehicleAttendanceDto
    };
    try {
      await Provider.of<EndAttendanceProvider>(context, listen: false)
          .EndAttendanceWithoutTemp(endWithoutTempRequestBody);

      // successCall();
    } catch (error) {
      logger.i('Error occurred 67: $error');
    }
    logger.i('e4');

    showLoadingDialog(context);
    await Future.delayed(Duration(seconds: 2));
    hideLoadingDialog(context);

    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void successCall() {
    final startAttendanceProvider =
        Provider.of<StartAttendanceProvider>(context, listen: false);

    final endAttendanceProvider =
        Provider.of<EndAttendanceProvider>(context, listen: false);

    logger.i('1 ');

    setState(() {
      successStatusStartWithoutTemp =
          startAttendanceProvider.startAttendanceWithoutTempResponse?.success;

      successStatusStartWithTemp =
          startAttendanceProvider.startAttendanceWithTempResponse?.success;

      successStatusEndWithoutTemp =
          endAttendanceProvider.endAttendanceWithoutTempResponse?.success;

      successStatusEndWithTemp =
          endAttendanceProvider.endAttendanceWithTempResponse?.success;
    });

    if (successStatusStartWithoutTemp == true ||
        successStatusStartWithTemp == true ||
        successStatusEndWithoutTemp == true ||
        successStatusEndWithTemp == true) {
      successStatus = true;
    } else {
      successStatus = false;
    }

    logger.i('Success Status : ${successStatus}');

    finalResponseStatusDialogBox(context);
  }

  void finalResponseStatusDialogBox(BuildContext context) {
    logger.i(successStatus);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
          if (successStatus == true) {
            _vehicleNumberController.clear();
            _driverLicenseController.clear();
            _driverNameController.clear();
            _currentMileageController.clear();
            _replaceVehicleNumberController.clear();
            _replaceDriverNICController.clear();
            _replaceCommentController.clear();

            Navigator.pop(context);
          }
        });
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: SuccessStatusAlertBox(
            successStatus: successStatus!,
          ),
        );
      },
    );
  }

  // expansion tile card toggle button function-------------------------------
  final ExpansionTileController controller = ExpansionTileController();

  bool isToggled = false;

  void toggleExpansion() {
    isToggled = !isToggled;
    setState(() {
      if (isToggled == false) {
        controller.collapse();
      } else {
        controller.expand();
      }
    });
  }

  //--------------------------------------------------------------------

  List<String> allVehicles = [];
  List<String> filteredVehicles = [];
  String? selectedVehicle;

  void vehicleNumberList() {
    // logger.i('B4 for loop');
    final findAllVehicles =
        Provider.of<FindAllVehiclesProvider>(context, listen: false);

    allVehicles.clear();

    for (int i = 0;
        i <
            findAllVehicles
                .findAllVehiclesResponse!.appVehicleMobileDtoList!.length;
        i++) {
      // logger.i('inside for loop');
      final vehicleDetailItem =
          findAllVehicles.findAllVehiclesResponse!.appVehicleMobileDtoList![i];
      allVehicles.add(vehicleDetailItem.vehicleRegNumber.toString());
    }
    logger.i('end of the for loop');
    // logger.i(allVehicles);
    logger.i(filteredVehicles);
    logger.i(selectedVehicle);
  }

  void filterVehicles(String query) {
    logger.i('inside the func');
    vehicleNumberList();

    setState(() {
      filteredVehicles = allVehicles
          .where(
              (vehicle) => vehicle.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (filteredVehicles.isEmpty) {
        selectedVehicle = null;
      } else if (filteredVehicles.contains(selectedVehicle)) {
        selectedVehicle = selectedVehicle;
      } else {
        selectedVehicle = null;
      }
    });

    showDropdown = filteredVehicles.isNotEmpty && query.isNotEmpty;
  }

  List<String> allLicenseNumbers = [];
  List<String> filteredLicenseNumbers = [];
  String? selectedLicenseNumber;

  void licenseNumberList() {
    logger.i('B4 for loop');
    final findAllLicenseNumbers =
        Provider.of<FindAllVehiclesProvider>(context, listen: false);

    allLicenseNumbers.clear();

    for (int i = 0;
        i <
            findAllLicenseNumbers
                .findAllVehiclesResponse!.appVehicleMobileDtoList!.length;
        i++) {
      final licenseNumberItem = findAllLicenseNumbers
          .findAllVehiclesResponse!.appVehicleMobileDtoList![i];

      // Using a simple conditional check with null-aware operator
      if (licenseNumberItem.driverDto?.licenseNum != null) {
        allLicenseNumbers
            .add(licenseNumberItem.driverDto!.licenseNum.toString());
      }
    }
    logger.i('end of the for loop');
    // logger.i(allLicenseNumbers);
    logger.i(filteredLicenseNumbers);
    logger.i(selectedLicenseNumber);
  }

  void filterLicenseNumbers(String query) {
    logger.i('inside the func 1');
    licenseNumberList();

    setState(() {
      filteredLicenseNumbers = allLicenseNumbers
          .where((licenseNumber) =>
              licenseNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (filteredLicenseNumbers.isEmpty) {
        selectedLicenseNumber = null;
      } else if (filteredLicenseNumbers.contains(selectedLicenseNumber)) {
        // Keep the selected vehicle if it's still in the filtered list
        selectedLicenseNumber = selectedLicenseNumber;
      } else {
        // Reset selection if the previously selected vehicle is not in the filtered list
        selectedLicenseNumber = null;
      }
    });
    showLicenseNumberDropdown =
        filteredLicenseNumbers.isNotEmpty && query.isNotEmpty;
  }

  // content design------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ApplicationColors.PURE_WHITE,
      statusBarIconBrightness: Brightness.dark,
    ));
    var screenSize = MediaQuery.of(context).size;
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);
    final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
        backgroundColor: ApplicationColors.PURE_WHITE,
        body: Container(
          // margin: ApplicationMarginValues.pageContainerMargin,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 0.0),
            child: Column(children: <Widget>[
              Container(
                  child: Stack(children: <Widget>[
                Container(
                  width: screenSize.width,
                  // height: 120,
                  height: screenSize.height / 7.42,
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
                      bottom: 8.0,
                      left: 8.0,
                      child: Row(children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TypeSelector()),
                            );
                          },
                          icon: SvgPicture.asset('assets/images/BackIcon.svg',
                              // width: 7.78,
                              // height: 20.259,
                              width: screenSize.width / 52.88,
                              height: screenSize.height / 43.95),
                        ),
                        Text('Daily Attendance',
                            style: TextStyle(
                                fontSize:
                                    ApplicationTextSizes.pageTitleTextValue,
                                fontFamily: 'Poppins',
                                fontWeight:
                                    ApplicationTextWeights.PageTitleTextWeight))
                      ])),
                ),
              ])),

              // Date---------------------------------------------------------
              // Container(
              //   margin: ApplicationMarginValues.pageTopInputFieldMargin,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         // flex: 4,
              //         child: Row(
              //           children: [
              //             Text(
              //               "Date  :  ",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: ApplicationTextWeights
              //                       .UserInputsLabelWeight),
              //             ),
              //             SvgPicture.asset(
              //               'assets/images/Calender.svg',
              //               height: 22.51,
              //               width: 22.51,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         margin: ApplicationMarginValues.textInputFieldInnerMargin,
              //         child: TextFormField(
              //           readOnly: true,
              //           controller: _dateTimeController,
              //           enabled: false,
              //           style: TextStyle(
              //             color: ApplicationColors.PURE_BLACK,
              //           ),
              //           decoration: InputDecoration(
              //             filled: true,
              //             fillColor: ApplicationColors.PURE_WHITE,
              //             border: OutlineInputBorder(),
              //           ),
              //         ),
              //         // ),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  child: CustomTextInput(
                inputController: _dateTimeController,
                titleText: "Date  :  ",
                inputEnabled: false,
              )),

              // Vehicle Number-------------------------------------------------
              Container(
                  child: CustomTextInput(
                inputController: _vehicleNumberController,
                titleText: "Vehicle Number  :  ",
                inputTextError: _vehicleNumberError,
                inputFormatters: [
                  VehicleNumberTextInputFormatter(),
                  LengthLimitingTextInputFormatter(8)
                ],
                onChange: (value) {
                  vehicleNumberList();
                  filterVehicles(value);
                },
              )),

              if (showDropdown)
                Positioned(
                    child: Container(
                  color: ApplicationColors.PURE_WHITE,
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300,
                      minHeight: 150,
                      maxWidth: 350,
                      minWidth: 100,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredVehicles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredVehicles[index]),
                          onTap: () {
                            setState(() {
                              showDropdown = false;
                            });

                            if (_driverLicenseController.text.isEmpty) {
                              _vehicleNumberController.text =
                                  filteredVehicles[index];

                              for (int i = 0;
                                  i <
                                      findAllVehiclesProvider
                                          .findAllVehiclesResponse!
                                          .appVehicleMobileDtoList!
                                          .length;
                                  i++) {
                                final vehicle = findAllVehiclesProvider
                                    .findAllVehiclesResponse
                                    ?.appVehicleMobileDtoList![i];

                                if (vehicle?.vehicleRegNumber ==
                                    _vehicleNumberController.text) {
                                  vehicleID = vehicle?.id;
                                  _driverLicenseController.text =
                                      '${vehicle!.driverDto!.licenseNum}';
                                  driverID = vehicle.driverDto!.id;
                                  _driverNameController.text =
                                      '${vehicle.driverDto!.cname}';
                                }
                              }
                            } else if (_driverLicenseController
                                .text.isNotEmpty) {
                              for (int i = 0;
                                  i <
                                      findAllVehiclesProvider
                                          .findAllVehiclesResponse!
                                          .appVehicleMobileDtoList!
                                          .length;
                                  i++) {
                                final vehicle = findAllVehiclesProvider
                                    .findAllVehiclesResponse
                                    ?.appVehicleMobileDtoList![i];
                                if (vehicle?.driverDto!.licenseNum ==
                                    _driverLicenseController.text) {
                                  _vehicleNumberController.text =
                                      '${vehicle?.vehicleRegNumber}';
                                  vehicleID = vehicle?.id;
                                  break;
                                } else {
                                  _vehicleNumberController.text =
                                      filteredVehicles[index];

                                  if (vehicle?.vehicleRegNumber ==
                                      _vehicleNumberController.text) {
                                    vehicleID = vehicle?.id;
                                  }
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                )),

              // Driver's License Number----------------------------------------
              Container(
                  child: CustomTextInput(
                inputController: _driverLicenseController,
                titleText: "Driver's Name  :  ",
                inputTextError: _licenseNumberError,
                inputFormatters: [
                  DriverLicenseTextInputFormatter(),
                  LengthLimitingTextInputFormatter(10)
                ],
                onChange: (value) {
                  licenseNumberList();
                  filterLicenseNumbers(value);
                },
              )),

              if (showLicenseNumberDropdown)
                Positioned(
                    child: Container(
                  color: ApplicationColors.PURE_WHITE,
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 300,
                      minHeight: 150,
                      maxWidth: 350,
                      minWidth: 100,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLicenseNumbers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredLicenseNumbers[index]),
                          onTap: () {
                            // Handle the selection

                            _driverLicenseController.text =
                                filteredLicenseNumbers[index];

                            setState(() {
                              showLicenseNumberDropdown = false;
                            });

                            if (_vehicleNumberController.text.isEmpty) {
                              _driverLicenseController.text =
                                  filteredLicenseNumbers[index];

                              for (int i = 0;
                                  i <
                                      findAllVehiclesProvider
                                          .findAllVehiclesResponse!
                                          .appVehicleMobileDtoList!
                                          .length;
                                  i++) {
                                final vehicle = findAllVehiclesProvider
                                    .findAllVehiclesResponse
                                    ?.appVehicleMobileDtoList![i];

                                if (vehicle?.driverDto!.licenseNum ==
                                    _driverLicenseController.text) {
                                  _driverNameController.text =
                                      '${vehicle!.driverDto!.cname}';

                                  _vehicleNumberController.text =
                                      '${vehicle.vehicleRegNumber}';

                                  driverID = vehicle.driverDto!.id;
                                }
                              }
                            } else if (_vehicleNumberController
                                .text.isNotEmpty) {
                              for (int i = 0;
                                  i <
                                      findAllVehiclesProvider
                                          .findAllVehiclesResponse!
                                          .appVehicleMobileDtoList!
                                          .length;
                                  i++) {
                                final vehicle = findAllVehiclesProvider
                                    .findAllVehiclesResponse
                                    ?.appVehicleMobileDtoList![i];
                                if (vehicle?.vehicleRegNumber ==
                                    _vehicleNumberController.text) {
                                  _driverLicenseController.text =
                                      '${vehicle?.driverDto!.licenseNum}';
                                  driverID = vehicle?.driverDto!.id;
                                  break;
                                } else {
                                  _driverLicenseController.text =
                                      filteredLicenseNumbers[index];

                                  if (vehicle?.driverDto!.licenseNum ==
                                      _driverLicenseController.text) {
                                    driverID = vehicle?.driverDto!.id;
                                  }
                                }
                              }
                            }

                            logger.i(filteredLicenseNumbers);
                            logger.i(selectedLicenseNumber);
                          },
                        );
                      },
                    ),
                  ),
                )),

              // Driver's Name--------------------------------------------------
              Container(
                  child: CustomTextInput(
                inputController: _driverNameController,
                titleText: "Driver's Name  :  ",
                inputTextError: _currentMileageError,
              )),

              // Replace Vehicle Details----------------------------------------
              Container(
                margin: ApplicationMarginValues.replaceBoxMargin,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 2.0,
                        color: ApplicationColors
                            .EXPANSION_TILE_BORDER), // Top border with width 3.0
                    bottom: BorderSide(
                        width: 2.0,
                        color: ApplicationColors
                            .EXPANSION_TILE_BORDER), // Bottom border with width 5.0
                  ),
                ),
                child: ExpansionTile(
                  controller: controller,
                  backgroundColor: ApplicationColors.BG_LIGHT_BLUE,
                  title: Text(
                    'Replace Vehicle / Driver Details',
                    style: TextStyle(
                        fontSize: ApplicationTextSizes.userInputFieldLabelValue,
                        fontFamily: 'Poppins',
                        fontWeight:
                            ApplicationTextWeights.UserInputsLabelWeight),
                  ),
                  trailing: CustomToggleButton(
                    changeToggleAction: toggleExpansion,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          'If a replacement driver or vehicle arrives, please fill in the following fields.',
                          style: TextStyle(
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight,
                            fontFamily: 'Poppins',
                            fontSize: ApplicationTextSizes.RememberMeTextValue,
                          )),
                    ),

                    // Replace Vehicle Number-----------------------------------

                    Container(
                        child: CustomTextInput(
                      inputController: _replaceVehicleNumberController,
                      titleText: "Vehicle Number  :  ",
                      inputEnabled: _vehicleNumberController.text.isEmpty ||
                              _driverLicenseController.text.isEmpty
                          ? false
                          : true,
                      inputFormatters: <TextInputFormatter>[
                        VehicleNumberTextInputFormatter(),
                      ],
                    )),

                    // Replace Driver's NIC Number--------------------------
                    Container(
                        child: CustomTextInput(
                      inputController: _replaceDriverNICController,
                      titleText: "Driver's NIC Number  :  ",
                      inputEnabled: _vehicleNumberController.text.isEmpty ||
                              _driverLicenseController.text.isEmpty
                          ? false
                          : true,
                      inputFormatters: <TextInputFormatter>[
                        DriverLicenseTextInputFormatter(),
                        LengthLimitingTextInputFormatter(10)
                      ],
                    )),

                    // Replace Comments-----------------------------------------
                    Container(
                        child: CustomTextInput(
                      inputController: _replaceCommentController,
                      titleText: 'Comments  :  ',
                      inputEnabled: _vehicleNumberController.text.isEmpty ||
                              _driverLicenseController.text.isEmpty
                          ? false
                          : true,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100)
                      ],
                    )),
                  ],
                ),
              ),

              // Current Vehicle Mileage-------------------------------------
              Container(
                  child: CustomTextInput(
                      inputController: _currentMileageController,
                      titleText: 'Current Vehicle Mileage  :  ',
                      inputTextError: _currentMileageError,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                      keyboardType: TextInputType.number)),

              Container(
                  margin: ApplicationMarginValues.pageInputFieldsMargin,
                  child: Row(
                    children: [
                      CustomSelectorButton(
                        changeToggleAction: () {
                          Provider.of<MileageUnit>(context, listen: false)
                              .toggleUnit();
                        },
                      ),
                    ],
                  )),

              // WorkIn WorkOut Buttons----------------------------------------
              Container(
                margin: ApplicationMarginValues.bottomButtonMargin,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        onPress: () {
                          // handleUserData();
                          print(_vehicleNumberController.text);

                          print('Work-In Button Pressed!');
                          Provider.of<MileageUnit>(context, listen: false)
                              .mileageToggleButton(
                                  _currentMileageController.text);

                          print(_currentMileageController.text);
                          print(Provider.of<MileageUnit>(context, listen: false)
                              .convertedMileageValue);
                          // print(finalMileageValue);
                          // Provider.of<FindAllDriversProvider>(context, listen: false)
                          //     .findAllDrivers();

                          // for (int i = 0; i < findAllVehiclesProvider.findAllVehiclesResponse!.appVehicleMobileDtoList.length; i++) {
                          //   final vehicle = findAllVehiclesProvider.findAllVehiclesResponse?.appVehicleMobileDtoList[i];
                          //   print('${vehicle?.id}' + ' - ' + '${vehicle?.vehicleRegNumber}');

                          //   if (findAllVehiclesProvider.findAllVehiclesResponse?.appVehicleMobileDtoList[i].vehicleRegNumber == _vehicleNumberController.text) {
                          //     vehicleID = findAllVehiclesProvider.findAllVehiclesResponse?.appVehicleMobileDtoList[i].id;
                          //   }
                          // }

                          for (int i = 0;
                              i <
                                  findAllVehiclesProvider
                                      .findAllVehiclesResponse!
                                      .appVehicleMobileDtoList!
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList![i];
                            if (vehicle?.vehicleRegNumber ==
                                _vehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            } else if (vehicle?.vehicleRegNumber ==
                                _replaceVehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            }
                          }

                          logger.i('A 2');

                          if (_replaceDriverNICController.text.isEmpty) {
                            for (int i = 0;
                                i <
                                    findAllVehiclesProvider
                                        .findAllVehiclesResponse!
                                        .appVehicleMobileDtoList!
                                        .length;
                                i++) {
                              final driverDetails = findAllVehiclesProvider
                                  .findAllVehiclesResponse
                                  ?.appVehicleMobileDtoList![i];
                              if (driverDetails?.vehicleRegNumber ==
                                  _vehicleNumberController.text) {
                                driverID = driverDetails!.driverDto!.id;
                              }
                            }
                          } else {
                            for (int i = 0;
                                i <
                                    findAllDriversProvider
                                        .findAllDriversResponse!
                                        .appDriverMobileDtoList
                                        .length;
                                i++) {
                              final driverDetails = findAllDriversProvider
                                  .findAllDriversResponse
                                  ?.appDriverMobileDtoList[i];
                              if (driverDetails?.nic ==
                                  _replaceDriverNICController.text) {
                                driverID = driverDetails!.id;
                              }
                            }
                          }
                          setState(() {
                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          workInButton();
                        },
                        innerText: 'Work-In',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderRadius: 4,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
                        textStyles: TextStyle(
                          fontSize:
                              ApplicationTextSizes.userInputFieldLabelValue,
                          fontFamily: 'Poppins',
                          fontWeight:
                              ApplicationTextWeights.UserInputsLabelWeight,
                          color: ApplicationColors.PURE_WHITE,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        onPress: () {
                          print(_vehicleNumberController.text);
                          print('Work-Out Button Pressed!');
                          Provider.of<MileageUnit>(context, listen: false)
                              .mileageToggleButton(
                                  _currentMileageController.text);

                          print(Provider.of<MileageUnit>(context, listen: false)
                              .convertedMileageValue);

                          //---------------------------------------------

                          for (int i = 0;
                              i <
                                  findAllVehiclesProvider
                                      .findAllVehiclesResponse!
                                      .appVehicleMobileDtoList!
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList![i];
                            if (vehicle?.vehicleRegNumber ==
                                _vehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            } else if (vehicle?.vehicleRegNumber ==
                                _replaceVehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            }
                          }

                          //----------------------------------------------

                          if (_replaceDriverNICController.text.isEmpty) {
                            for (int i = 0;
                                i <
                                    findAllVehiclesProvider
                                        .findAllVehiclesResponse!
                                        .appVehicleMobileDtoList!
                                        .length;
                                i++) {
                              final driverDetails = findAllVehiclesProvider
                                  .findAllVehiclesResponse
                                  ?.appVehicleMobileDtoList![i];
                              if (driverDetails?.vehicleRegNumber ==
                                  _vehicleNumberController.text) {
                                driverID = driverDetails!.driverDto!.id;
                              }
                            }
                          } else {
                            for (int i = 0;
                                i <
                                    findAllDriversProvider
                                        .findAllDriversResponse!
                                        .appDriverMobileDtoList
                                        .length;
                                i++) {
                              final driverDetails = findAllDriversProvider
                                  .findAllDriversResponse
                                  ?.appDriverMobileDtoList[i];
                              if (driverDetails?.nic ==
                                  _replaceDriverNICController.text) {
                                driverID = driverDetails!.id;
                              }
                            }
                          }

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          workOutButton();
                        },
                        innerText: 'Work-Out',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderRadius: 4,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
                        textStyles: TextStyle(
                          fontSize:
                              ApplicationTextSizes.userInputFieldLabelValue,
                          fontFamily: 'Poppins',
                          fontWeight:
                              ApplicationTextWeights.UserInputsLabelWeight,
                          color: ApplicationColors.PURE_WHITE,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}

class VehicleNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(r'[A-Z0-9-]');
    String filteredText =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}

class DriverLicenseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(r'[A-Z0-9-]');
    String filteredText =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}
