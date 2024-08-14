import 'dart:async';
import 'package:Guard_Room_Application/components/custom_alert_dialog.dart';
import 'package:Guard_Room_Application/components/custom_alert_dialog_button.dart';
import 'package:Guard_Room_Application/components/custom_button.dart';
import 'package:Guard_Room_Application/components/custom_selector_button.dart';
import 'package:Guard_Room_Application/components/custom_toggle_button.dart';
import 'package:Guard_Room_Application/components/success_alert_box.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sample_flutter_application_1/components/custom_alert_dialog_button.dart';
// import 'package:sample_flutter_application_1/components/custom_selector_button.dart';
// import 'package:sample_flutter_application_1/components/custom_toggle_button.dart';
// import 'package:sample_flutter_application_1/components/success_alert_box.dart';
// import 'package:sample_flutter_application_1/constraints/textSizes.dart';
// import 'package:sample_flutter_application_1/notifiers/mileage_unit.dart';
// import 'package:sample_flutter_application_1/providers/end_attendance_provider.dart';
// import 'package:sample_flutter_application_1/providers/find_all_drivers_provider.dart';
// import 'package:sample_flutter_application_1/providers/find_all_vehicles_provider.dart';
// import 'package:sample_flutter_application_1/providers/login_provider.dart';
// import 'package:sample_flutter_application_1/providers/start_attendance_provider.dart';
// import 'package:sample_flutter_application_1/screens/type_selector.dart';
// import 'package:sample_flutter_application_1/components/custom_alert_dialog.dart';
// import 'package:sample_flutter_application_1/components/custom_button.dart';
// import 'package:sample_flutter_application_1/constraints/colors.dart';
// import 'package:sample_flutter_application_1/constraints/marginValues.dart';

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
  final TextEditingController _currentTimeController = TextEditingController();

  final List<String> _provinceDropdownItems = [
    'CP',
    'EP',
    'NC',
    'NE',
    'NW',
    'SG',
    'SP',
    'UP',
    'WP',
    'N/A'
  ];
  String? _selectedVehicleProvince;

  final List<String> _replaceProvinceDropdownItems = [
    'CP',
    'EP',
    'NC',
    'NE',
    'NW',
    'SG',
    'SP',
    'UP',
    'WP',
    'N/A'
  ];
  String? _selectedReplaceVehicleProvince;

  var logger = Logger();
  final loginProvider = Provider.of<LoginProvider>;
  final findAllVehiclesProvider = Provider.of<FindAllVehiclesProvider>;
  final findAllDriversProvider = Provider.of<FindAllDriversProvider>;
  final startAttendanceProvider = Provider.of<StartAttendanceProvider>;
  final endAttendanceProvider = Provider.of<EndAttendanceProvider>;

  // DateTime? _selectedDate;

  // Method to show the date picker
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _currentDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
  //     });
  //   }
  // }

  // TimeOfDay _selectedTime = TimeOfDay.now();

  // Method to show time picker
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );

  //   if (pickedTime != null && pickedTime != _selectedTime) {
  //     setState(() {
  //       _selectedTime = pickedTime;

  //       _currentTimeController.text = (pickedTime.hour < 10
  //               ? "0" + "${pickedTime.hour}"
  //               : "${pickedTime.hour}") +
  //           ":" +
  //           (pickedTime.minute < 10
  //                   ? "0" + "${pickedTime.minute}"
  //                   : "${pickedTime.minute}")
  //               .split(' ')[0];
  //     });
  //   } else {
  //     setState(() {
  //       _currentTimeController.text = (_selectedTime.hour < 10
  //               ? "0" + "${_selectedTime.hour}"
  //               : "${_selectedTime.hour}") +
  //           ":" +
  //           (_selectedTime.minute < 10
  //                   ? "0" + "${_selectedTime.minute}"
  //                   : "${_selectedTime.minute}")
  //               .split(' ')[0];
  //     });
  //   }
  // }

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
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startClock();
    getCurrentDate();
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
          content: AlertDialogBox(
              // alertDialogText:
              //     'Cannot proceed with invalid inputs! Please try again.'
          ),
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
          content: AlertDialogBox(
              // alertDialogText:
              //     'Mandatory fields (*) cannot be empty! Please try again.'
          ),
        );
      },
    );
  }

  String? _dateError;
  String? _vehicleNumberError;
  String? _licenseNumberError;
  String? _driverNameError;
  String? _currentMileageError;
  String? _timeError;
  String? combinedDateTime;
  String? driverName;
  String? finalResponseStatus;

  bool isAllFilled = false;
  bool isRequiredFilled = false;
  bool isVehicleValId = false;
  bool isDriverId = false;

  bool requiredVehicleNumberFilled = false;
  bool requiredDriverDetailFilled = false;

  //  Check all field empty or not
  void checkFIlledAllFields() {
    setState(() {
      _dateError = _currentDateController.text.isEmpty ? 'Date is empty' : null;
      _currentMileageError = _currentMileageController.text.isEmpty
          ? 'Mileage cannot be empty'
          : null;
    });

    if (_currentMileageController.text.isEmpty == false) {
      isAllFilled = true;
    } else {
      isAllFilled = false;
    }
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
      // _timeError =
      //     _currentTimeController.text.isEmpty ? 'Time cannot be empty' : null;
      _driverNameError =
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
      // _driverNameController.text.isEmpty == false;
      requiredDriverDetailFilled = true;
      print('driver details okay');
    } else {
      // _driverNameController.text.isEmpty == true;
      requiredDriverDetailFilled = false;
      print('driver details not okay');
    }

    if (requiredVehicleNumberFilled == true &&
        requiredDriverDetailFilled == true) {
      isRequiredFilled = true;
    } else {
      isRequiredFilled = false;
    }
  }

  // Work in button function
  void workInButton() {
    setState(() {
      combinedDateTime =
          '${_dateController.text}' + ' ' + '${_timeController.text}';
    });

    if (isRequiredFilled == true && isAllFilled == true) {
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        print('all are okay');
        print(vehicleID);
        workInButtonDialogBox(context);
      }
    } else if (isRequiredFilled == false && isAllFilled == true) {
      print('errors with required fields');
      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == true && isAllFilled == false) {
      print('errors with all fields');
      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == false && isAllFilled == false) {
      print('errors with required and all inputs');
      invalidFieldAlertDialogBox(context);
      getCurrentDate();
      print(combinedDateTime);
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
      logger.i('meee inne ');
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        print('all are okay');
        workOutButtonDialogBox(context);
      }
    } else if (isRequiredFilled == false && isAllFilled == true) {
      print('errors with required fields');
      emptyRequiredFieldsAlertDialogBox(context);
    } else if (isRequiredFilled == true && isAllFilled == false) {
      print('errors with all fields');
      invalidFieldAlertDialogBox(context);
    } else if (isRequiredFilled == false && isAllFilled == false) {
      print('errors with required and all inputs');
      invalidFieldAlertDialogBox(context);
      getCurrentDate();
      // print(combinedDateTime);
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
                // print('@#@#@#@');
                endWithWithoutSelector();
                Navigator.of(context).pop();
              },
              alertDialogText:
                  'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text} ${_replaceVehicleNumberController.text}:  ?'),
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
      print('cccccccccc');
      endAttendanceWithoutTempFunc();
    } else {
      print('dddddddddd');
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

      // successCall();
    } catch (error) {
      // print('Error occurred: $error');
      logger.i('Error occurred 67: $error');
      // successCall();
    }
    logger.i('ephe');
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

      // successCall();

      logger.i('finally done');
    } catch (error) {
      // print('Error occurred 67: $error');
      logger.i('Error occurred 67: $error');
      // successCall();
    }
    logger.i('fphe');

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
      // print('Error occurred: $error');
      logger.i('Error occurred 67: $error');
      // successCall();
    }

    logger.i('gphe');
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
      // await Provider.of<EndAttendanceProvider>(context, listen: false)
      //     .EndAttendanceWithoutTemp(vehicleID, driverID,
      //         _currentMileageController.text, userName, combinedDateTime);

      await Provider.of<EndAttendanceProvider>(context, listen: false)
          .EndAttendanceWithoutTemp(endWithoutTempRequestBody);

      // successCall();
    } catch (error) {
      // print('Error occurred: $error');
      logger.i('Error occurred 67: $error');
      // successCall();
    }
    // logger.i('hphe');
    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  // final bool successStatus;

  bool? successStatusStartWithoutTemp;
  bool? successStatusStartWithTemp;
  bool? successStatusEndWithoutTemp;
  bool? successStatusEndWithTemp;
  bool? successStatus;

  void successCall() {
    final startAttendanceProvider =
        Provider.of<StartAttendanceProvider>(context, listen: false);

    final endAttendanceProvider =
        Provider.of<EndAttendanceProvider>(context, listen: false);

    // logger.i(startAttendanceProvider.startAttendanceWithoutTempResponse!.success);
    logger.i('1 ');
    // logger.i(successStatus);
    logger.i('2');

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

    // bool? successStatus;
    logger.i('ao');

    if (successStatusStartWithoutTemp == true ||
        successStatusStartWithTemp == true ||
        successStatusEndWithoutTemp == true ||
        successStatusEndWithTemp == true) {
      // setState(() {
      //   successStatus = true;
      // });
      successStatus = true;
    } else {
      // setState(() {
      //   successStatus = false;
      // });
      successStatus = false;
    }

    logger.i('wait stop here');
    logger.i(successStatus);
    logger.i('wait go ');
    finalResponseStatusDialogBox(context);
  }

  void finalResponseStatusDialogBox(BuildContext context) {
    logger.i(successStatus);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: SuccessStatusAlertBox(
              // successAlertMainText: '${finalResponseStatus}',
              successStatus: successStatus!,
              successAlertMainText: 'Saved Successfully',
              successAlertSubText: 'Saved your item successfully'),
        );
      },
    );
    // successStatus = false;
  }

  // expansion tile card toggle button function-------------------------------
  final ExpansionTileController controller = ExpansionTileController();

  bool isToggled = false;

  void toggleExpansion() {
    isToggled = !isToggled;
    setState(() {
      // isToggled = !isToggled;
      if (isToggled == false) {
        controller.collapse();
      } else {
        controller.expand();
      }
    });
  }

  // content design------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);
    final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    // final startAttendanceProvider =
    //     Provider.of<StartAttendanceProvider>(context);
    // final endAttendanceProvider = Provider.of<EndAttendanceProvider>(context);
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
                  height: screenSize.height / 7.419,
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
                              width: screenSize.width / 52.8828,
                              height: screenSize.height / 43.9451),
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
              Container(
                margin: ApplicationMarginValues.pageTopInputFieldMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Date  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          SvgPicture.asset(
                            'assets/images/Calender.svg',
                            height: 22.51,
                            width: 22.51,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      // flex: 6,
                      // child: GestureDetector(
                      //   onTap: () => _selectDate(context),
                      child: TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ApplicationColors.PURE_WHITE,
                          border: OutlineInputBorder(),
                          // suffixIcon: IconButton(
                          //   icon:
                          //       SvgPicture.asset('assets/images/Calender.svg',
                          //           // height: 22.51,
                          //           // width: 22.51,
                          //           height: screenSize.height / 39.5506,
                          //           width: screenSize.height / 39.5506),
                          //   onPressed: () => _selectDate(context),
                          // )
                        ),
                      ),
                      // ),
                    ),
                  ],
                ),
              ),

              // Vehicle Number-------------------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Vehicle Number  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                color: ApplicationColors.RED_COLOR,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      // flex: 6,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  'Province',
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .provinceDropdownTitle,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  dropdownColor: ApplicationColors.PURE_WHITE,
                                  iconEnabledColor:
                                      ApplicationColors.PURE_BLACK,
                                  value: _selectedVehicleProvince,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedVehicleProvince = newValue;
                                    });
                                  },
                                  items: _provinceDropdownItems
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 7,
                            child: TextField(
                              controller: _vehicleNumberController,
                              enabled:
                                  _replaceVehicleNumberController.text.isEmpty
                                      ? true
                                      : false,
                              inputFormatters: [
                                VehicleNumberTextInputFormatter(),
                                LengthLimitingTextInputFormatter(8)
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ApplicationColors.PURE_WHITE,
                                border: OutlineInputBorder(),
                                errorText: _vehicleNumberError
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Driver's License Number----------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Driver's License Number  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                color: ApplicationColors.RED_COLOR,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      child: TextFormField(
                        controller: _driverLicenseController,
                        enabled: _replaceDriverNICController.text.isEmpty
                            ? true
                            : false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        inputFormatters: [
                          DriverLicenseTextInputFormatter(),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ApplicationColors.PURE_WHITE,
                          border: OutlineInputBorder(),
                          errorText: _licenseNumberError
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Driver's Name--------------------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Driver's Name  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                color: ApplicationColors.RED_COLOR,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                        margin:
                            ApplicationMarginValues.textInputFieldInnerMargin,
                        child: GestureDetector(
                          onTap: () {
                            for (int i = 0;
                                i <
                                    findAllDriversProvider
                                        .findAllDriversResponse!
                                        .appDriverMobileDtoList
                                        .length;
                                i++) {
                              final driver = findAllDriversProvider
                                  .findAllDriversResponse
                                  ?.appDriverMobileDtoList[i];
                              // print('${driver?.cname}' +
                              //     ' - ' +
                              //     '${driver?.licenseNum}' +
                              //     ' - ' +
                              //     '${driver?.nic}' +
                              //     ' - ' +
                              //     '${driver?.id}');
                              if (driver?.licenseNum ==
                                  _driverLicenseController.text) {
                                driverID = driver?.id;
                                _driverNameController.text = '${driver?.cname}';
                                // driverName = driver?.cname;
                              }
                            }
                          },
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _driverNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ApplicationColors.PURE_WHITE,
                              border: OutlineInputBorder(),
                              // errorText: _driverNameError,
                            ),
                          ),
                        )
                        // flex: 6,

                        ),
                  ],
                ),
              ),

              // Replace Vehicle Details----------------------------------------
              Container(
                margin: ApplicationMarginValues.replaceBoxMargin,
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
                    // backgroundColor: isToggled ? ApplicationColors.BUTTON_COLOR_BLUE : ApplicationColors.TOGGLE_BUTTON_OFF_COLOR,
                    // dotColor: ApplicationColors.PURE_WHITE,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          'If a replacement driver or vehicle arrives, please fill in the following fields.......',
                          style: TextStyle(
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight,
                            fontFamily: 'Poppins',
                            fontSize: ApplicationTextSizes.RememberMeTextValue,
                          )),
                    ),

                    // Replace Vehicle Number-----------------------------------
                    Container(
                      margin:
                          ApplicationMarginValues.replaceBoxInputFieldsMargin,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // flex: 4,
                            child: Row(
                              children: [
                                Text(
                                  "Vehicle Number  :  ",
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .userInputFieldLabelValue,
                                      fontFamily: 'Poppins',
                                      fontWeight: ApplicationTextWeights
                                          .UserInputsLabelWeight),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .userInputFieldLabelValue,
                                      color: ApplicationColors.RED_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 10),
                          Container(
                            margin: ApplicationMarginValues
                                .textInputFieldInnerMargin,
                            // flex: 6,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Province',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      DropdownButton<String>(
                                        dropdownColor:
                                            ApplicationColors.PURE_WHITE,
                                        iconEnabledColor:
                                            ApplicationColors.PURE_BLACK,
                                        value: _selectedReplaceVehicleProvince,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedReplaceVehicleProvince =
                                                newValue;
                                          });
                                        },
                                        items: _replaceProvinceDropdownItems
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 6,
                                  child: TextFormField(
                                    // enabled: _vehicleNumberController.text == null ? true : false,
                                    // enabled: (if ( _vehicleNumberController.text == null) {
                                    //   true;
                                    // } else {
                                    //   false;
                                    // } ),
                                    // _vehicleNumberController.text.isEmpty ? enabled : true : enabled : false
                                    enabled:
                                        _vehicleNumberController.text.isEmpty
                                            ? true
                                            : false,
                                    controller: _replaceVehicleNumberController,
                                    // enabled: false,
                                    inputFormatters: [
                                      VehicleNumberTextInputFormatter()
                                    ],
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: ApplicationColors.PURE_WHITE,
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Replace Driver's NIC Number--------------------------
                    Container(
                      margin:
                          ApplicationMarginValues.replaceBoxInputFieldsMargin,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // flex: 4,
                            child: Row(
                              children: [
                                Text(
                                  "Driver's NIC Number  :  ",
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .userInputFieldLabelValue,
                                      fontFamily: 'Poppins',
                                      fontWeight: ApplicationTextWeights
                                          .UserInputsLabelWeight),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .userInputFieldLabelValue,
                                      color: ApplicationColors.RED_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 10),
                          Container(
                            margin: ApplicationMarginValues
                                .textInputFieldInnerMargin,
                            // flex: 6,
                            child: TextFormField(
                              controller: _replaceDriverNICController,
                              enabled: _driverLicenseController.text.isEmpty
                                  ? true
                                  : false,
                              inputFormatters: [
                                DriverLicenseTextInputFormatter(),
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ApplicationColors.PURE_WHITE,
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Replace Comments-----------------------------------------
                    Container(
                      margin:
                          ApplicationMarginValues.replaceBoxInputFieldsMargin,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // flex: 4,
                            child: Row(
                              children: [
                                Text(
                                  "Comments  :  ",
                                  style: TextStyle(
                                      fontSize: ApplicationTextSizes
                                          .userInputFieldLabelValue,
                                      fontFamily: 'Poppins',
                                      fontWeight: ApplicationTextWeights
                                          .UserInputsLabelWeight),
                                ),
                                // Text(
                                //   "*",
                                //   style: TextStyle(
                                //       fontSize: ApplicationTextSizes
                                //           .userInputFieldLabelValue,
                                //       color: ApplicationColors.RED_COLOR,
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            // flex: 6,
                            child: TextFormField(
                              controller: _replaceCommentController,
                              maxLength: 100,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ApplicationColors.PURE_WHITE,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Current Vehicle Mileage-------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Current Vehicle Mileage  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          // Text(
                          //   "*",
                          //   style: TextStyle(
                          //       fontSize: ApplicationTextSizes
                          //           .userInputFieldLabelValue,
                          //       color: ApplicationColors.RED_COLOR,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      // flex: 6,
                      child: Column(
                        children: <Widget>[
                          Container(
                            // flex: 6,
                            child: TextFormField(
                              // enabled: false,
                              controller: _currentMileageController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6)
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ApplicationColors.PURE_WHITE,
                                border: OutlineInputBorder(),
                                // errorText: _currentMileageError
                              ),
                            ),
                          ),
                          // SizedBox(height: 10),
                          Container(
                              margin:
                                  ApplicationMarginValues.mileageMarginValue,
                              // flex: 4,
                              child: Row(
                                children: [
                                  CustomSelectorButton(
                                    changeToggleAction: () {
                                      Provider.of<MileageUnit>(context,
                                              listen: false)
                                          .toggleUnit();
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Current Time----------------------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      // flex: 4,
                      child: Row(
                        children: [
                          Text(
                            "Current Time  :  ",
                            style: TextStyle(
                                fontSize: ApplicationTextSizes
                                    .userInputFieldLabelValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                          // Text(
                          //   "*",
                          //   style: TextStyle(
                          //       fontSize: ApplicationTextSizes
                          //           .userInputFieldLabelValue,
                          //       color: ApplicationColors.RED_COLOR,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      // flex: 6,
                      // child: GestureDetector(
                      //   onTap: () => _selectTime(context),
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: _timeController,
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ApplicationColors.PURE_WHITE,
                          border: OutlineInputBorder(),
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.access_time),
                          //   onPressed: () => _selectTime(context),
                          // ),
                          // errorText: _timeError,
                        ),
                      ),
                      // ),
                    ),
                  ],
                ),
              ),

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
                                      .appVehicleMobileDtoList
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList[i];
                            if (vehicle?.vehicleRegNumber ==
                                _vehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            } else if (vehicle?.vehicleRegNumber ==
                                _replaceVehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            }
                          }

                          for (int i = 0;
                              i <
                                  findAllDriversProvider.findAllDriversResponse!
                                      .appDriverMobileDtoList.length;
                              i++) {
                            final driver = findAllDriversProvider
                                .findAllDriversResponse
                                ?.appDriverMobileDtoList[i];
                            // print('${driver?.cname}' +
                            //     ' - ' +
                            //     '${driver?.licenseNum}' +
                            //     ' - ' +
                            //     '${driver?.nic}' +
                            //     ' - ' +
                            //     '${driver?.id}');
                            if (driver?.licenseNum ==
                                _driverLicenseController.text) {
                              driverID = driver?.id;
                              _driverNameController.text = '${driver?.cname}';
                            } else if (driver?.nic ==
                                _replaceDriverNICController.text) {
                              driverID = driver?.id;
                              // _driverNameController.text = '${driver?.cname}';
                            }
                          }

                          setState(() {
                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });
                          // print('${loginProvider.loginresponse!.loginDetailsDto.mobileNo}');

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          workInButton();
                          // vehicleID = null;
                          setState(() {
                            // _vehicleNumberController.clear();
                            // vehicleID = null;
                          });
                        },
                        innerText: 'Work-In',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderWidth: 0.0,
                        borderRadius: 4,
                        // buttonWidth: 200,
                        // buttonHeight: 45,
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
                          // setState(() {
                          //   vehicleID = null;
                          //   driverID = null;
                          // });
                          print(_vehicleNumberController.text);
                          print('Work-Out Button Pressed!');
                          Provider.of<MileageUnit>(context, listen: false)
                              .mileageToggleButton(
                                  _currentMileageController.text);
                          
                          print(Provider.of<MileageUnit>(context, listen: false)
                              .convertedMileageValue);

                          for (int i = 0;
                              i <
                                  findAllVehiclesProvider
                                      .findAllVehiclesResponse!
                                      .appVehicleMobileDtoList
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList[i];
                            if (vehicle?.vehicleRegNumber ==
                                _vehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            } else if (vehicle?.vehicleRegNumber ==
                                _replaceVehicleNumberController.text) {
                              vehicleID = vehicle?.id;
                            }
                          }

                          for (int i = 0;
                              i <
                                  findAllDriversProvider.findAllDriversResponse!
                                      .appDriverMobileDtoList.length;
                              i++) {
                            final driver = findAllDriversProvider
                                .findAllDriversResponse
                                ?.appDriverMobileDtoList[i];
                            // print('${driver?.cname}' +
                            //     ' - ' +
                            //     '${driver?.licenseNum}' +
                            //     ' - ' +
                            //     '${driver?.nic}' +
                            //     ' - ' +
                            //     '${driver?.id}');
                            if (driver?.licenseNum ==
                                _driverNameController.text) {
                              driverID = driver?.id;
                              _driverNameController.text = '${driver?.cname}';
                            } else if (driver?.nic ==
                                _replaceDriverNICController.text) {
                              driverID = driver?.id;
                              // _driverNameController.text = '${driver?.cname}';
                            }
                          }

                          // if (endAttendanceProvider
                          //             .endAttendanceWithTempResponse!.success ==
                          //         true ||
                          //     endAttendanceProvider
                          //             .endAttendanceWithoutTempResponse!
                          //             .success ==
                          //         true) {
                          //   setState(() {
                          //     finalResponseStatus =
                          //         'Successfully submitted(End Attendance) !';
                          //   });
                          // } else {
                          //   setState(() {
                          //     finalResponseStatus =
                          //         'Error in submitting(End Attendance) !';
                          //   });
                          // }

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          workOutButton();

                          setState(() {
                            // _vehicleNumberController.clear();
                            // vehicleID = null;
                          });
                        },
                        innerText: 'Work-Out',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderWidth: 0.0,
                        borderRadius: 4,
                        // buttonWidth: 200,
                        // buttonHeight: 45,
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

              // Container(
              //     margin: ApplicationMarginValues.replaceBoxMargin,
              //     child: ListView(
              //       children: <Widget>[
              //         // Using a Column to wrap the ListTile and expanded content
              //         Column(
              //           children: [
              //             // The ListTile without onTap to disable touch on the title
              //             ListTile(
              //               // leading: Icon(Icons.info),
              //               title: Text('Expand me'),
              //               subtitle: Text('Click the icon to expand'),
              //               trailing: CustomToggleButton(
              //                 changeToggleAction: toggleExpansion,
              //               ),
              //             ),
              //             // Conditionally show the children based on the _isExpanded state
              //             if (isToggled)
              //               Column(
              //                 children: <Widget>[
              //                   ListTile(title: Text('Item 1')),
              //                   ListTile(title: Text('Item 2')),
              //                   ListTile(title: Text('Item 3')),
              //                 ],
              //               ),
              //           ],
              //         ),
              //       ],
              //     ))
            ]),
          ),
        ));
  }

  void handleUserData() {
    // Function to handle the user data
    // logger.i(
    //     'success - ${startAttendanceProvider.startAttendanceWithoutTempResponse!.errorDetailsList}');
    print('Data fetched');
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

//------------------------------------------------------------------------------

// class SuccessAlert extends StatefulWidget {
//   @override
//   _SuccessAlert createState() => _SuccessAlert();
// }

// class _SuccessAlert extends State<SuccessAlert> {
//   var logger = Logger();
//   void finalResponseStatusDialogBox(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.all(0.0),
//           content: SuccessStatusAlertBox(
//               // successAlertMainText: '${finalResponseStatus}',
//               successAlertMainText: 'Saved Successfully',
//               successAlertSubText: 'Saved your item successfully'),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final startAttendanceProvider =
//         Provider.of<StartAttendanceProvider>(context);
//     return Scaffold(
//       backgroundColor: ApplicationColors.PURE_WHITE,
//         body: Container(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(top: 0.0),
//             child: Column(children: <Widget>[
//               Container(margin: ApplicationMarginValues.bottomButtonMargin,
//                 child:  CustomButton(
//                         onPress: () {
//                           // handleUserData();
//                           finalResponseStatusDialogBox(context);
//                           // hhhh
//                           print('Work-In Button Pressed!');

//                           logger.i('me uyane unath mal 6');
//                           Future<void> fetchData() async {
//                             await Future.delayed(Duration(seconds: 5));
//                             logger.i(
//                                 'success - ${startAttendanceProvider.startAttendanceWithoutTempResponse!.errorDetailsList}');
//                             print('Data fetched');
//                           }

//                           logger.i(
//                               'success - ${startAttendanceProvider.startAttendanceWithoutTempResponse!.errorDetailsList}');
//                           logger.i('me uyane unath mal 7');
//                         },
//                         innerText: 'Work-In',
//                         backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
//                         borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
//                         borderWidth: 0.0,
//                         borderRadius: 4,
//                         // buttonWidth: 200,
//                         // buttonHeight: 45,
//                         buttonWidth:200,
//                         buttonHeight: 100,
//                         textStyles: TextStyle(
//                           fontSize:
//                               ApplicationTextSizes.userInputFieldLabelValue,
//                           fontFamily: 'Poppins',
//                           fontWeight:
//                               ApplicationTextWeights.UserInputsLabelWeight,
//                           color: ApplicationColors.PURE_WHITE,
//                         ),
//                       ),
//                     ), ]        
//                 )))
//         );
//   }
// }
