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
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/providers/vehicle_in_provider.dart';
import 'package:Guard_Room_Application/providers/vehicle_out_provider.dart';
import 'package:Guard_Room_Application/screens/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class DailyTrip extends StatefulWidget {
  @override
  _DailyTrip createState() => _DailyTrip();
}

class _DailyTrip extends State<DailyTrip> {
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
  final TextEditingController _tripIDController = TextEditingController();
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

  // Method to show the time picker
  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime,
  //   );
  //   print(_selectedTime);

  //   if (pickedTime != null && pickedTime != _selectedTime) {
  //     setState(() {
  //       _selectedTime = pickedTime;
  //       if (pickedTime.hour < 10) {
  //         pickedTime.hour == "0" + "${pickedTime.hour}";
  //       }
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

  var logger = Logger();
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
    // logger.i(formattedDate);
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
              //     '“Mandatory fields (*) cannot be empty! Please try again.'
          ),
        );
      },
    );
  }

  String formattedTime = '';
  String? _dateError;
  String? _vehicleNumberError;
  String? _licenseNumberError;
  String? _driverNameError;
  String? _currentMileageError;
  String? _timeError;
  String? _tripIdError;
  int? vehicleID;
  int? driverID;
  int? userID;
  String? userName;
  String? combinedDateTime;

  bool isAllFilled = false;
  bool isRequiredFilled = false;

  bool requiredVehicleNumberFilled = false;
  bool requiredDriverDetailFilled = false;

  //  Check all field empty or not
  void checkFIlledAllFields() {
    print('now in all field check state');
    setState(() {
      _dateError = _currentDateController.text.isEmpty ? 'Date is empty' : null;
      _driverNameError =
          _driverNameController.text.isEmpty ? 'Driver Name is empty' : null;
      _timeError = _currentTimeController.text.isEmpty ? 'TIme is empty' : null;
      _tripIdError = _tripIDController.text.isEmpty ? 'TIme is empty' : null;
    });

    if (_tripIDController.text.isEmpty == false) {
      isAllFilled = true;
      print('A');
    } else {
      isAllFilled = false;
      print('B');
    }
  }

  // Check required field empty or not
  void checkFilledRequiredFields() {
    print('now in required fields checking function');
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
      setState(() {
        isRequiredFilled = true;
      });
      // print('C');
    } else {
      isRequiredFilled = false;
      // print('D');
    }
  }

  // Start button function
  void startButton() {
    setState(() {
      combinedDateTime =
          '${_dateController.text}' + ' ' + '${_timeController.text}';
    });
    // print('now start button');
    // print(combinedDateTime);
    // print(_timeController.text);
    if (isRequiredFilled == true && isAllFilled == true) {
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        print('all are okay');
        startButtonDialogBox(context);
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
    }
  }

  // End button function
  void endButton() {
    setState(() {
      combinedDateTime =
          '${_dateController.text}' + ' ' + '${_timeController.text}';
    });
    // print('now end button');
    // print(isRequiredFilled);
    // print(isAllFilled);
    if (isRequiredFilled == true && isAllFilled == true) {
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        print('all are okay');
        endButtonDialogBox(context);
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
    }
  }

  // Start button yes command------------------------------
  void startButtonDialogBox(BuildContext context) {
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
                  'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text} ${_replaceVehicleNumberController.text}: ?'),
        );
      },
    );
  }

  // End button yes command-----------------------------------
  void endButtonDialogBox(BuildContext context) {
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
                  'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text} ${_replaceVehicleNumberController.text}: ?'),
        );
      },
    );
  }

  // with temp or without temp selector functions-----------------
  void startWithWithoutSelector() {
    if (_replaceDriverNICController.text.isEmpty == true &&
        _replaceVehicleNumberController.text.isEmpty == true) {
      vehicleInWithoutTempFunc();
    } else {
      vehicleInWithTempFunc();
    }
  }

  void endWithWithoutSelector() {
    if (_replaceDriverNICController.text.isEmpty == true &&
        _replaceVehicleNumberController.text.isEmpty == true) {
      vehicleOutWithoutTempFunc();
    } else {
      vehicleOutWithTempFunc();
    }
  }

  // Functions to pass data to providers-------------------------------
  void vehicleInWithTempFunc() async {
    Map<String, dynamic> vehicleInOutRecordDto = {};

    vehicleInOutRecordDto['vehicleId'] = vehicleID;
    vehicleInOutRecordDto['driverId'] = driverID;
    vehicleInOutRecordDto['tempVehicleNo'] =
        _replaceVehicleNumberController.text;
    vehicleInOutRecordDto['tempDriverNic'] = _replaceDriverNICController.text;
    vehicleInOutRecordDto['recordTime'] = combinedDateTime;
    vehicleInOutRecordDto['addedBy'] = userID;
    vehicleInOutRecordDto['comment'] = _replaceCommentController.text;
    vehicleInOutRecordDto['officer'] = userName;
    vehicleInOutRecordDto['type'] = 'IN';
    vehicleInOutRecordDto['tripId'] = _tripIDController.text;
    vehicleInOutRecordDto['mileage'] = _currentMileageController.text;

    Map<String, dynamic> vehicleInWithTempRequestBody = {
      'vehicleInOutRecordDto': vehicleInOutRecordDto
    };
    try {
      await Provider.of<VehicleInProvider>(context, listen: false)
          .VehicleInWIthTemp(vehicleInWithTempRequestBody);
    } catch (error) {
      // print('Error occurredsss: $error');
      logger.i('Error occurred 67: $error');
    }
    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void vehicleInWithoutTempFunc() async {
    Map<String, dynamic> vehicleInOutRecordDto = {};

    vehicleInOutRecordDto['vehicleId'] = vehicleID;
    vehicleInOutRecordDto['driverId'] = driverID;
    vehicleInOutRecordDto['recordTime'] = combinedDateTime;
    vehicleInOutRecordDto['addedBy'] = userID;
    vehicleInOutRecordDto['comment'] = 'No comments';
    vehicleInOutRecordDto['officer'] = userName;
    vehicleInOutRecordDto['type'] = 'IN';
    vehicleInOutRecordDto['tripId'] = _tripIDController.text;
    vehicleInOutRecordDto['mileage'] = _currentMileageController.text;

    Map<String, dynamic> vehicleInWithoutTempRequestBody = {
      'vehicleInOutRecordDto': vehicleInOutRecordDto
    };
    try {
      await Provider.of<VehicleInProvider>(context, listen: false)
          .VehicleInWithoutTemp(vehicleInWithoutTempRequestBody);
    } catch (error) {
      // print('Error occurredeeee: $error');
      logger.i('Error occurred 67: $error');
    }
    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void vehicleOutWithTempFunc() async {
    Map<String, dynamic> vehicleInOutRecordDto = {};

    vehicleInOutRecordDto['vehicleId'] = vehicleID;
    vehicleInOutRecordDto['driverId'] = driverID;
    vehicleInOutRecordDto['tempVehicleNo'] =
        _replaceVehicleNumberController.text;
    vehicleInOutRecordDto['tempDriverNic'] = _replaceDriverNICController.text;
    vehicleInOutRecordDto['recordTime'] = combinedDateTime;
    vehicleInOutRecordDto['addedBy'] = userID;
    vehicleInOutRecordDto['comment'] = 'No comments';
    vehicleInOutRecordDto['officer'] = userName;
    vehicleInOutRecordDto['type'] = 'OUT';
    vehicleInOutRecordDto['tripId'] = _tripIDController.text;
    vehicleInOutRecordDto['mileage'] = _currentMileageController.text;

    Map<String, dynamic> vehicleOutWithTempRequestBody = {
      'vehicleInOutRecordDto': vehicleInOutRecordDto
    };
    try {
      await Provider.of<VehicleOutProvider>(context, listen: false)
          .VehicleOutWithTemp(vehicleOutWithTempRequestBody);
    } catch (error) {
      // print('Error occurreddddd: $error');
      logger.i('Error occurred 67: $error');
    }
    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  void vehicleOutWithoutTempFunc() async {
    Map<String, dynamic> vehicleInOutRecordDto = {};

    vehicleInOutRecordDto['vehicleId'] = vehicleID;
    vehicleInOutRecordDto['driverId'] = driverID;
    vehicleInOutRecordDto['recordTime'] = combinedDateTime;
    vehicleInOutRecordDto['addedBy'] = userID;
    vehicleInOutRecordDto['comment'] = 'Out comments';
    vehicleInOutRecordDto['officer'] = userName;
    vehicleInOutRecordDto['type'] = 'OUT';
    vehicleInOutRecordDto['tripId'] = _tripIDController.text;
    vehicleInOutRecordDto['mileage'] = _currentMileageController.text;

    Map<String, dynamic> vehicleOutWithoutTempRequestBody = {
      'vehicleInOutRecordDto': vehicleInOutRecordDto
    };
    try {
      await Provider.of<VehicleOutProvider>(context, listen: false)
          .VehicleOutWithoutTemp(vehicleOutWithoutTempRequestBody);
      // print(userID);
    } catch (error) {
      // print('Error occurredpppp: $error');
      logger.i('Error occurred 67: $error');
    }
    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  bool? successStatusVehicleIntWithoutTemp;
  bool? successStatusVehicleInWithTemp;
  bool? successStatusVehicleOutWithoutTemp;
  bool? successStatusVehicleOutWithTemp;
  bool? successStatus;

  String? errorCode;

  void successCall() {
    final vehicleInProvider =
        Provider.of<VehicleInProvider>(context, listen: false);

    final vehicleOutProvider =
        Provider.of<VehicleOutProvider>(context, listen: false);

    setState(() {
      successStatusVehicleIntWithoutTemp =
          vehicleInProvider.vehicleInWithTempResponse?.success;

      successStatusVehicleInWithTemp =
          vehicleInProvider.vehicleInWithoutTempResponse?.success;

      successStatusVehicleOutWithoutTemp =
          vehicleOutProvider.vehicleOutWithTempResponse?.success;

      successStatusVehicleOutWithTemp =
          vehicleOutProvider.vehicleOutWithoutTempResponse?.success;

    });

    logger.i('ao');

    if (successStatusVehicleIntWithoutTemp == true ||
        successStatusVehicleInWithTemp == true ||
        successStatusVehicleOutWithoutTemp == true ||
        successStatusVehicleOutWithTemp == true) {
      setState(() {
        successStatus = true;
      });
    } else {
      setState(() {
        successStatus = false;
      });
      errorCode = vehicleInProvider.vehicleInWithTempResponse?.errorDetailsList.first.code;
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
              successStatus: successStatus!,
              // successAlertMainText: 'Saved Successfully',
              // successAlertSubText: 'Saved your item successfully'
          ),
        );
      },
    );
  }

  // expansion tile card toggle button function-------------------------------
  final ExpansionTileController controller = ExpansionTileController();

  bool isToggled = false;

  void toggleExpansion() {
    // isToggled = !isToggled;
    setState(() {
      isToggled = !isToggled;
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
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);
    final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    var screenSize = MediaQuery.of(context).size;
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
                  // padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  // color: ApplicationColors.YellowColor,
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
                              // height: 20.259
                              width: screenSize.width / 52.8828,
                              height: screenSize.height / 43.9451),
                        ),
                        Text('Daily Trips',
                            style: TextStyle(
                                fontSize:
                                    ApplicationTextSizes.pageTitleTextValue,
                                fontFamily: 'Poppins',
                                fontWeight:
                                    ApplicationTextWeights.PageTitleTextWeight))
                      ])),
                ),
              ])),

              // Date--------------------------------------------------------
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
                          // GestureDetector(
                          //   onTap: () => _selectDate(context),
                          //   child: SvgPicture.asset(
                          //     'assets/images/Calender.svg',
                          //     height: 22.51,
                          //     width: 22.51,
                          //   ),
                          // ),
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
                          //   icon: SvgPicture.asset(
                          //       'assets/images/Calender.svg',
                          //       // height: 22.51,
                          //       // width: 22.51,
                          //       height: screenSize.height / 39.5506,
                          //       width: screenSize.height / 39.5506),
                          //   onPressed: () => _selectDate(context),
                          // )
                        ),
                      ),
                      // ),
                    ),
                  ],
                ),
              ),

              // Trip Id------------------------------------------------------
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Trip ID  :  ",
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
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      child: TextFormField(
                        controller: _tripIDController,
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
                          // Expanded(
                          //   flex: 3,
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         'Province',
                          //         style: TextStyle(
                          //             fontSize: ApplicationTextSizes
                          //                 .provinceDropdownTitle,
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //       DropdownButton<String>(
                          //         dropdownColor: ApplicationColors.PURE_WHITE,
                          //         iconEnabledColor:
                          //             ApplicationColors.PURE_BLACK,
                          //         value: _selectedVehicleProvince,
                          //         onChanged: (String? newValue) {
                          //           setState(() {
                          //             _selectedVehicleProvince = newValue;
                          //           });
                          //         },
                          //         items: _provinceDropdownItems
                          //             .map<DropdownMenuItem<String>>(
                          //                 (String value) {
                          //           return DropdownMenuItem<String>(
                          //             value: value,
                          //             child: Text(value),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(width: 10),
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
                              print('${driver?.cname}' +
                                  ' - ' +
                                  '${driver?.licenseNum}' +
                                  ' - ' +
                                  '${driver?.nic}' +
                                  ' - ' +
                                  '${driver?.id}');
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
                            child: Row(
                              children: [
                                Text("Vehicle Number  :  ",
                                    style: TextStyle(
                                        fontSize: ApplicationTextSizes
                                            .userInputFieldLabelValue,
                                        fontFamily: 'Poppins',
                                        fontWeight: ApplicationTextWeights
                                            .UserInputsLabelWeight)),
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
                          Container(
                            margin: ApplicationMarginValues
                                .textInputFieldInnerMargin,
                            // flex: 6,
                            child: Row(
                              children: <Widget>[
                                // Expanded(
                                //   flex: 4,
                                //   child: Column(
                                //     children: [
                                //       Text(
                                //         'Province',
                                //         style: TextStyle(
                                //             fontSize: ApplicationTextSizes
                                //                 .provinceDropdownTitle,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //       DropdownButton<String>(
                                //         dropdownColor:
                                //             ApplicationColors.PURE_WHITE,
                                //         iconEnabledColor:
                                //             ApplicationColors.PURE_BLACK,
                                //         value: _selectedReplaceVehicleProvince,
                                //         onChanged: (String? newValue) {
                                //           setState(() {
                                //             _selectedReplaceVehicleProvince =
                                //                 newValue;
                                //           });
                                //         },
                                //         items: _replaceProvinceDropdownItems
                                //             .map<DropdownMenuItem<String>>(
                                //                 (String value) {
                                //           return DropdownMenuItem<String>(
                                //             value: value,
                                //             child: Text(value),
                                //           );
                                //         }).toList(),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(width: 10),
                                Expanded(
                                  flex: 6,
                                  child: TextFormField(
                                    controller: _replaceVehicleNumberController,
                                    enabled:
                                        _vehicleNumberController.text.isEmpty
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
                                      // errorText: _vehicleNumberError
                                    ),
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
                            child: Row(
                              children: [
                                Text("Driver's NIC Number  :  ",
                                    style: TextStyle(
                                        fontSize: ApplicationTextSizes
                                            .userInputFieldLabelValue,
                                        fontFamily: 'Poppins',
                                        fontWeight: ApplicationTextWeights
                                            .UserInputsLabelWeight)),
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
                          Container(
                            margin: ApplicationMarginValues
                                .textInputFieldInnerMargin,
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
                                border: OutlineInputBorder(),
                              ),
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
                            child: Row(
                              children: [
                                Text("Comments  :  ",
                                    style: TextStyle(
                                        fontSize: ApplicationTextSizes
                                            .userInputFieldLabelValue,
                                        fontFamily: 'Poppins',
                                        fontWeight: ApplicationTextWeights
                                            .UserInputsLabelWeight)),
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
                          Container(
                            margin: ApplicationMarginValues
                                .textInputFieldInnerMargin,
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
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TextFormField(
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
                          Container(
                              margin:
                                  ApplicationMarginValues.mileageMarginValue,
                              child: Row(
                                children: [
                                  // CustomSelectorButton(),
                                  // SizedBox(width: 5),
                                  // Text(
                                  //   'km',
                                  //   // mileageUnit,
                                  //   // Provider.of<MileageUnit>(context).unit,
                                  //   style: TextStyle(
                                  //       fontSize: ApplicationTextSizes
                                  //           .userInputFieldLabelValue,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  // SizedBox(width: 25),
                                  // CustomSelectorButton(),
                                  // SizedBox(width: 5),
                                  // Text(
                                  //   'miles',
                                  //   // mileageUnit,
                                  //   // Provider.of<MileageUnit>(context).unit,
                                  //   style: TextStyle(
                                  //       fontSize: ApplicationTextSizes
                                  //           .userInputFieldLabelValue,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  // SizedBox(width: 25),
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

              // Current Time Duplicate
              Container(
                margin: ApplicationMarginValues.pageInputFieldsMargin,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Current time  :  ",
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
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      // flex: 6,
                      // child: GestureDetector(
                      //   onTap: () => _selectTime(context),
                      child: TextFormField(
                        readOnly: true,
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
                        ),
                      ),
                      // ),
                    ),
                  ],
                ),
              ),

              // Start End Buttons----------------------------------------
              Container(
                margin: ApplicationMarginValues.bottomButtonMargin,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        onPress: () {
                          // logger.i(screenSize.height);
                          // logger.i(screenSize.width);
                          // print('Start Button Pressed!');
                          Provider.of<MileageUnit>(context, listen: false)
                              .mileageToggleButton(
                                  _currentMileageController.text);
                          
                          // print(Provider.of<MileageUnit>(context, listen: false)
                          //     .convertedMileageValue);

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

                          setState(() {
                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          startButton();
                        },
                        innerText: 'Start',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderWidth: 0.0,
                        borderRadius: 4,
                        buttonWidth: 200,
                        buttonHeight: 45,
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
                          logger.i('End Button Pressed!');
                          Provider.of<MileageUnit>(context, listen: false)
                              .mileageToggleButton(
                                  _currentMileageController.text);
                          
                          // print(Provider.of<MileageUnit>(context, listen: false)
                          //     .convertedMileageValue);

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

                          setState(() {
                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          endButton();
                        },
                        innerText: 'End',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderWidth: 0.0,
                        borderRadius: 4,
                        buttonWidth: 200,
                        buttonHeight: 45,
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
              )
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
