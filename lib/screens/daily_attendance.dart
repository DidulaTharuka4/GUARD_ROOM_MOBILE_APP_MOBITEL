import 'dart:async';
import 'package:Guard_Room_Application/components/alert_boxes.dart';
import 'package:Guard_Room_Application/components/AlertBoxes/invalid_input_alert_box.dart';
import 'package:Guard_Room_Application/components/AlertBoxes/confirmation_alert_box.dart';
import 'package:Guard_Room_Application/components/Buttons/main_button.dart';
import 'package:Guard_Room_Application/components/Buttons/custom_selector_button.dart';
import 'package:Guard_Room_Application/components/main_text_input.dart';
import 'package:Guard_Room_Application/components/Buttons/toggle_button.dart';
import 'package:Guard_Room_Application/components/AlertBoxes/success_error_alert_box.dart';
import 'package:Guard_Room_Application/components/vehicle_list.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/notifiers/mileage_unit.dart';
import 'package:Guard_Room_Application/providers/end_attendance_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/providers/start_attendance_provider.dart';
import 'package:Guard_Room_Application/components/AppBars/form_page_appbar.dart';
import 'package:Guard_Room_Application/screens/type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonType {
  workIn,
  workOut,
  empty,
}

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

  // final List<String> _provinceDropdownItems = [
  //   'CP',
  //   'EP',
  //   'NC',
  //   'NE',
  //   'NW',
  //   'SG',
  //   'SP',
  //   'UP',
  //   'WP',
  //   'N/A'
  // ];
  // String? _selectedVehicleProvince;

  // final List<String> _replaceProvinceDropdownItems = [
  //   'CP',
  //   'EP',
  //   'NC',
  //   'NE',
  //   'NW',
  //   'SG',
  //   'SP',
  //   'UP',
  //   'WP',
  //   'N/A'
  // ];
  // String? _selectedReplaceVehicleProvince;

  ButtonType currentButtonState = ButtonType.empty;

  // MyWidget({required this.currentButtonState});

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

  String? _dateError;
  String? _vehicleNumberError;
  String? _licenseNumberError;
  String? _driverNameError;
  String? _currentMileageError;
  String? _timeError;
  String? combinedDateTime;
  String? driverName;
  String? finalResponseStatus;
  bool submitButtonClicked = false;

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

  bool _isDropdownExpanded = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    startClock();
    getCurrentDate();
    // VehicleFilter.vehicleNumberList();

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
      _dateError = _currentDateController.text.isEmpty ? 'Date is empty' : null;
      _currentMileageError = _currentMileageController.text.isEmpty
          ? 'Mileage cannot be empty'
          : null;
    });
    isAllFilled = true;
  }

  // Check required field empty or not
  void checkFilledRequiredFields() {
    setState(() {
      // _vehicleNumberError = _vehicleNumberController.text.isEmpty
      //     ? 'Vehicle Number cannot be empty'
      //     : null;
      // _licenseNumberError = _driverLicenseController.text.isEmpty
      //     ? 'License Number cannot be empty'
      //     : null;
      // _currentMileageError = _currentMileageController.text.isEmpty
      //     ? 'Mileage cannot be empty'
      //     : null;
      // _timeError =
      //     _currentTimeController.text.isEmpty ? 'Time cannot be empty' : null;
      _driverNameError =
          _driverNameController.text.isEmpty ? 'Name cannot be empty' : null;
    });

    if (_vehicleNumberController.text.isEmpty == false ||
        _replaceVehicleNumberController.text.isEmpty == false) {
      requiredVehicleNumberFilled = true;
      logger.i('vehicle number okay');
    } else {
      requiredVehicleNumberFilled = false;
      logger.i('vehicle number not okay');
    }

    if (_driverLicenseController.text.isEmpty == false ||
        _replaceDriverNICController.text.isEmpty == false) {
      // _driverNameController.text.isEmpty == false;
      requiredDriverDetailFilled = true;
      logger.i('driver details okay');
    } else {
      // _driverNameController.text.isEmpty == true;
      requiredDriverDetailFilled = false;
      logger.i('driver details not okay');
    }

    if (requiredVehicleNumberFilled == true &&
        requiredDriverDetailFilled == true &&
        _currentMileageController.text.isEmpty == false) {
      isRequiredFilled = true;
    } else {
      isRequiredFilled = false;
    }
  }

  void workTypeSelectionButton() {
    logger.i('work Type Selection Button');

    setState(() {
      combinedDateTime = '${_dateController.text} ${_timeController.text}';
    });
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
      // logger.i('meee inne ');
      if (vehicleID == null && driverID == null) {
        logger.i('invalid vehicle number and driver license number !');
      } else if (vehicleID == null && driverID != null) {
        logger.i('invalid vehicle number !');
      } else if (vehicleID != null && driverID == null) {
        logger.i('invalid driver license number !');
      } else {
        logger.i('all are okay');
        workOutButtonDialogBox(context);
        MyWidget(currentState: AlertType.okayOrNotOkayDialog);
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
            // successAlertMainText: '${finalResponseStatus}',
            successStatus: successStatus!,
          ),
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
    // setState(() {
    //   if (isToggled == false) {
    //     controller.collapse();
    //   } else {
    //     controller.expand();
    //   }
    // });

    if (isToggled == false) {
      // controller.collapse();
      if (_vehicleNumberController.text.isEmpty == false &&
          _driverLicenseController.text.isEmpty == false) {
        controller.collapse();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('This is a Snackbar!'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      // controller.expand();
      if (_vehicleNumberController.text.isEmpty == false &&
          _driverLicenseController.text.isEmpty == false) {
        controller.expand();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('This is a Snackbar!'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  //--------------------------------------------------------------------

  // List<String> allVehicles = [];
  // List<String> filteredVehicles = [];
  // String? selectedVehicle;

  // void vehicleNumberList() {
  //   // logger.i('B4 for loop');
  //   final findAllVehicles =
  //       Provider.of<FindAllVehiclesProvider>(context, listen: false);

  //   allVehicles.clear();

  //   for (int i = 0;
  //       i <
  //           findAllVehicles
  //               .findAllVehiclesResponse!.appVehicleMobileDtoList!.length;
  //       i++) {
  //     // logger.i('inside for loop');
  //     final vehicleDetailItem =
  //         findAllVehicles.findAllVehiclesResponse!.appVehicleMobileDtoList![i];
  //     allVehicles.add(vehicleDetailItem.vehicleRegNumber.toString());
  //   }
  //   logger.i('end of the for loop');
  //   // logger.i(allVehicles);
  //   logger.i(filteredVehicles);
  //   logger.i(selectedVehicle);
  // }

  // void filterVehicles(String query) {
  //   logger.i('inside the func');
  //   vehicleNumberList();

  //   setState(() {
  //     filteredVehicles = allVehicles
  //         .where(
  //             (vehicle) => vehicle.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //     if (filteredVehicles.isEmpty) {
  //       selectedVehicle = null;
  //     } else if (filteredVehicles.contains(selectedVehicle)) {
  //       // Keep the selected vehicle if it's still in the filtered list
  //       selectedVehicle = selectedVehicle;
  //     } else {
  //       // Reset selection if the previously selected vehicle is not in the filtered list
  //       selectedVehicle = null;
  //     }
  //   });

  //   showDropdown = filteredVehicles.isNotEmpty && query.isNotEmpty;
  // }

  //--------------------------------------------------------------------------

  // driver's license number drop down-----------------------------------------

  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ApplicationColors.PURE_WHITE,
      statusBarIconBrightness: Brightness.dark,
    ));
    var screenSize = MediaQuery.of(context).size;
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);
    final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    return Scaffold(
        backgroundColor: ApplicationColors.PURE_WHITE,
        appBar: const FormPageAppBarWithShadow(),
        // appBar: AppBar(
        //   backgroundColor: ApplicationColors.PURE_WHITE,
        //   leading: IconButton(
        //     // padding: const EdgeInsets.all(0.0),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: SvgPicture.asset('assets/images/BackIcon.svg',
        //         width: screenSize.width / 52.88,
        //         height: screenSize.height / 43.94),
        //   ),
        //   title: const Text('Daily Attendance',
        //       style: TextStyle(
        //           fontSize: ApplicationTextSizes.pageTitleTextValue,
        //           fontFamily: 'Poppins',
        //           fontWeight: ApplicationTextWeights.PageTitleTextWeight)),
        // ),
        body: Container(
          // margin: ApplicationMarginValues.pageContainerMargin,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 0.0),
            child: Column(children: <Widget>[
              // Stack(children: <Widget>[
              //   Container(
              //     width: screenSize.width,
              //     // height: 120,
              //     height: screenSize.height / 7.419,
              //     decoration: BoxDecoration(
              //         color: ApplicationColors.PURE_WHITE,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black26,
              //             offset: Offset(0, 4),
              //             blurRadius: 10,
              //             spreadRadius: 1,
              //           ),
              //         ]),
              //   ),
              //   Container(
              //     child: Positioned(
              //         bottom: 8.0,
              //         left: 8.0,
              //         child: Row(children: <Widget>[
              //           IconButton(
              //             onPressed: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => TypeSelector()),
              //               );
              //             },
              //             icon: SvgPicture.asset('assets/images/BackIcon.svg',
              //                 // width: 7.78,
              //                 // height: 20.259,
              //                 width: screenSize.width / 52.8828,
              //                 height: screenSize.height / 43.9451),
              //           ),
              //           Text('Daily Attendance',
              //               style: TextStyle(
              //                   fontSize:
              //                       ApplicationTextSizes.pageTitleTextValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight:
              //                       ApplicationTextWeights.PageTitleTextWeight))
              //         ])),
              //   ),
              // ]),

              Container(
                  margin: ApplicationMarginValues.formPageTopMargin,
                  child: CustomTextInput(
                    inputController: _dateTimeController,
                    titleText: "Date  :  ",
                    inputEnabled: false,
                    isRequired: false,
                  )),

              // Vehicle Number-------------------------------------------------
              // Container(
              //   margin: ApplicationMarginValues.pageInputFieldsMargin,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         // flex: 4,
              //         child: Row(
              //           children: [
              //             Text(
              //               "Vehicle Number  :  ",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: ApplicationTextWeights
              //                       .UserInputsLabelWeight),
              //             ),
              //             Text(
              //               "*",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   color: ApplicationColors.RED_COLOR,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       ),
              //       // SizedBox(height: 10),
              //       Container(
              //         margin: ApplicationMarginValues.textInputFieldInnerMargin,
              //         // flex: 6,
              //         child: Row(
              //           children: <Widget>[
              //             Expanded(
              //               // flex: 7,
              //               child: TextField(
              //                 controller: _vehicleNumberController,
              //                 // enabled:
              //                 //     _replaceVehicleNumberController.text.isEmpty
              //                 //         ? true
              //                 //         : false,
              //                 inputFormatters: [
              //                   VehicleNumberTextInputFormatter(),
              //                   LengthLimitingTextInputFormatter(8)
              //                 ],
              //                 decoration: InputDecoration(
              //                     filled: true,
              //                     fillColor: ApplicationColors.PURE_WHITE,
              //                     border: OutlineInputBorder(),
              //                     prefixIcon: Icon(Icons.search),
              //                     errorText: _vehicleNumberError),
              //                 onChanged: (value) {
              //                   vehicleNumberList();
              //                   filterVehicles(value);

              //                   logger.i(filteredVehicles);
              //                   logger.i(selectedVehicle);

              //                   //     licenseNumberList();
              //                   // filterLicenseNumbers(value);

              //                   logger.i('12');
              //                   // if (value.isEmpty) {
              //                   //   _driverNameController.text = '';
              //                   //   _driverLicenseController.text = '';
              //                   // } else {
              //                   //   for (int i = 0;
              //                   //       i <
              //                   //           findAllVehiclesProvider
              //                   //               .findAllVehiclesResponse!
              //                   //               .appVehicleMobileDtoList!
              //                   //               .length;
              //                   //       i++) {
              //                   //     final vehicle = findAllVehiclesProvider
              //                   //         .findAllVehiclesResponse
              //                   //         ?.appVehicleMobileDtoList![i];
              //                   //     if (vehicle?.vehicleRegNumber ==
              //                   //         _vehicleNumberController.text) {
              //                   //       // vehicleID = vehicle?.id;
              //                   //       driverName = vehicle!.driverDto!.cname;
              //                   //       _driverNameController.text =
              //                   //           '${vehicle!.driverDto!.cname}';
              //                   //       _driverLicenseController.text =
              //                   //           '${vehicle!.driverDto!.licenseNum}';
              //                   //     }
              //                   //   }
              //                   // }
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  child: CustomTextInput(
                      inputController: _vehicleNumberController,
                      titleText: "Vehicle Number  :  ",
                      // inputTextError: _vehicleNumberError,
                      inputFormatters: [
                        VehicleNumberTextInputFormatter(),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      onChange: (value) {
                        vehicleProvider.filterVehicles(context, value);
                        // vehicleNumberList();
                        // filterVehicles(value);
                      },
                      isRequired: true,
                      buttonClickStatus: submitButtonClicked)),

              if (vehicleProvider.showDropdown)
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
                      // itemCount: filteredVehicles.length,
                      itemCount: vehicleProvider.filteredVehicles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(vehicleProvider.filteredVehicles[index]),
                          onTap: () {
                            // Handle the selection of a vehicle

                            // _vehicleNumberController.text =
                            //     filteredVehicles[index];

                            setState(() {
                              vehicleProvider.showDropdown = false;
                            });

                            if (_driverLicenseController.text.isEmpty) {
                              _vehicleNumberController.text =
                                  vehicleProvider.filteredVehicles[index];

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
                                  driverID = vehicle?.driverDto!.id;
                                  _driverNameController.text =
                                      '${vehicle!.driverDto!.cname}';
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
                                      vehicleProvider.filteredVehicles[index];

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
              // Container(
              //   margin: ApplicationMarginValues.pageInputFieldsMargin,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         child: Row(
              //           children: [
              //             Text(
              //               "Driver's License Number  :  ",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: ApplicationTextWeights
              //                       .UserInputsLabelWeight),
              //             ),
              //             Text(
              //               "*",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   color: ApplicationColors.RED_COLOR,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         margin: ApplicationMarginValues.textInputFieldInnerMargin,
              //         child: TextFormField(
              //             controller: _driverLicenseController,
              //             // enabled: _replaceDriverNICController.text.isEmpty
              //             //     ? true
              //             //     : false,
              //             validator: (value) {
              //               if (value == null || value.isEmpty) {
              //                 return 'This field is required';
              //               }
              //               return null;
              //             },
              //             inputFormatters: [
              //               DriverLicenseTextInputFormatter(),
              //               LengthLimitingTextInputFormatter(10)
              //             ],
              //             decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: ApplicationColors.PURE_WHITE,
              //                 border: OutlineInputBorder(),
              //                 errorText: _licenseNumberError),
              //             onChanged: (value) {
              //               licenseNumberList();
              //               filterLicenseNumbers(value);

              //               // if (value.isEmpty) {
              //               //   _derNameController.text = '';
              //               // } else {
              //               //   if (_vehicleNumberController.text.isNotEmpty) {
              //               //     for (int i = 0;
              //               //         i <
              //               //             findAllVehiclesProvider
              //               //                 .findAllVehiclesResponse!
              //               //                 .appVehicleMobileDtoList!
              //               //                 .length;
              //               //         i++) {
              //               //       final vehicle = findAllVehiclesProvider
              //               //           .findAllVehiclesResponse
              //               //           ?.appVehicleMobileDtoList![i];

              //               //       if (vehicle?.vehicleRegNumber ==
              //               //           _vehicleNumberController.text) {
              //               //         _driverLicenseController.text =
              //               //             '${vehicle?.driverDto!.licenseNum}';
              //               //         _driverNameController.text =
              //               //             '${vehicle?.driverDto!.cname}';
              //               //         driverID = vehicle?.driverDto!.id;
              //               //         break;
              //               //       } else {
              //               //         for (int i = 0;
              //               //             i <
              //               //                 findAllDriversProvider
              //               //                     .findAllDriversResponse!
              //               //                     .appDriverMobileDtoList
              //               //                     .length;
              //               //             i++) {
              //               //           final driver = findAllDriversProvider
              //               //               .findAllDriversResponse
              //               //               ?.appDriverMobileDtoList[i];
              //               //           if (driver?.licenseNum ==
              //               //               _driverLicenseController.text) {
              //               //             driverID = driver?.id;
              //               //             _driverNameController.text =
              //               //                 '${driver?.cname}';
              //               //           }
              //               //         }
              //               //       }
              //               //     }
              //               //   } else if (_vehicleNumberController
              //               //       .text.isEmpty) {
              //               //     for (int i = 0;
              //               //         i <
              //               //             findAllVehiclesProvider
              //               //                 .findAllVehiclesResponse!
              //               //                 .appVehicleMobileDtoList!
              //               //                 .length;
              //               //         i++) {
              //               //       final vehicle = findAllVehiclesProvider
              //               //           .findAllVehiclesResponse
              //               //           ?.appVehicleMobileDtoList![i];

              //               //       if (vehicle?.driverDto!.licenseNum ==
              //               //           _driverLicenseController.text) {
              //               //         _vehicleNumberController.text =
              //               //             '${vehicle?.vehicleRegNumber}';
              //               //         vehicleID = vehicle?.id;
              //               //         _driverNameController.text =
              //               //             '${vehicle?.driverDto!.cname}';
              //               //       }
              //               //     }
              //               //   }
              //               // }

              //               //-----------------------------------------

              //               // if (value.isEmpty) {
              //               //   _driverNameController.text = '';
              //               // } else {
              //               //   for (int i = 0;
              //               //       i <
              //               //           findAllDriversProvider
              //               //               .findAllDriversResponse!
              //               //               .appDriverMobileDtoList
              //               //               .length;
              //               //       i++) {
              //               //     final driver = findAllDriversProvider
              //               //         .findAllDriversResponse
              //               //         ?.appDriverMobileDtoList[i];
              //               //     print('${driver?.cname}' +
              //               //         ' - ' +
              //               //         '${driver?.licenseNum}' +
              //               //         ' - ' +
              //               //         '${driver?.nic}' +
              //               //         ' - ' +
              //               //         '${driver?.id}');
              //               //     if (driver?.licenseNum ==
              //               //         _driverLicenseController.text) {
              //               //       driverID = driver?.id;
              //               //       if (driver?.cname != null) {
              //               //         _driverNameController.text =
              //               //             '${driver?.cname}';
              //               //       }
              //               //       // driverName = driver?.cname;
              //               //     }
              //               //   }
              //               // }

              //               // if (value.isEmpty) {
              //               //   _driverNameController.text = '';
              //               //   _vehicleNumberController.text = '';
              //               // } else {
              //               //   for (int i = 0;
              //               //       i <
              //               //           findAllVehiclesProvider
              //               //               .findAllVehiclesResponse!
              //               //               .appVehicleMobileDtoList!
              //               //               .length;
              //               //       i++) {
              //               //     final vehicle = findAllVehiclesProvider
              //               //         .findAllVehiclesResponse
              //               //         ?.appVehicleMobileDtoList![i];
              //               //     if (vehicle?.driverDto!.licenseNum ==
              //               //         _driverLicenseController.text) {
              //               //       if (_vehicleNumberController.text.isEmpty) {
              //               //         _vehicleNumberController.text =
              //               //             '${vehicle!.vehicleRegNumber}';
              //               //       }
              //               //       _driverNameController.text =
              //               //           '${vehicle!.driverDto!.cname}';
              //               //     }
              //               //   }
              //               // }

              //               //====================================
              //             }),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  child: CustomTextInput(
                      inputController: _driverLicenseController,
                      titleText: "Driver's License Number  :  ",
                      // inputTextError: _licenseNumberError,
                      inputFormatters: [
                        DriverLicenseTextInputFormatter(),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      onChange: (value) {
                        licenseNumberList();
                        filterLicenseNumbers(value);
                      },
                      isRequired: true,
                      buttonClickStatus: submitButtonClicked)),

              if (showLicenseNumberDropdown)
                Positioned(
                    child: Container(
                  color: ApplicationColors.PURE_WHITE,
                  // color: ApplicationColors.BACKGROUND_BLUE,
                  constraints: const BoxConstraints(maxHeight: 200),

                  // decoration: BoxDecoration(
                  //   border: Border.all(width: 1.0),
                  // ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
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
                                      '${vehicle?.vehicleRegNumber}';

                                  driverID = vehicle?.driverDto!.id;
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
              // Container(
              //   margin: ApplicationMarginValues.pageInputFieldsMargin,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         child: Row(
              //           children: [
              //             Text(
              //               "Driver's Name  :  ",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: ApplicationTextWeights
              //                       .UserInputsLabelWeight),
              //             ),
              //             Text(
              //               "*",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   color: ApplicationColors.RED_COLOR,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //           margin:
              //               ApplicationMarginValues.textInputFieldInnerMargin,
              //           child: GestureDetector(
              //             onTap: () {
              //               // for (int i = 0;
              //               //     i <
              //               //         findAllDriversProvider
              //               //             .findAllDriversResponse!
              //               //             .appDriverMobileDtoList
              //               //             .length;
              //               //     i++) {
              //               //   final driver = findAllDriversProvider
              //               //       .findAllDriversResponse
              //               //       ?.appDriverMobileDtoList[i];
              //               //   // print('${driver?.cname}' +
              //               //   //     ' - ' +
              //               //   //     '${driver?.licenseNum}' +
              //               //   //     ' - ' +
              //               //   //     '${driver?.nic}' +
              //               //   //     ' - ' +
              //               //   //     '${driver?.id}');
              //               //   if (driver?.licenseNum ==
              //               //       _driverLicenseController.text) {
              //               //     driverID = driver?.id;
              //               //     _driverNameController.text = '${driver?.cname}';
              //               //     // driverName = driver?.cname;
              //               //   }
              //               // }
              //             },
              //             child: TextFormField(
              //               enabled: false,
              //               readOnly: true,
              //               style: TextStyle(
              //                 color: ApplicationColors.PURE_BLACK,
              //               ),
              //               validator: (value) {
              //                 if (value == null || value.isEmpty) {
              //                   return 'Please enter some text';
              //                 }
              //                 return null;
              //               },
              //               controller: _driverNameController,
              //               decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: ApplicationColors.PURE_WHITE,
              //                 border: OutlineInputBorder(),
              //                 // errorText: _driverNameError,
              //               ),
              //             ),
              //           )),
              //     ],
              //   ),
              // ),

              Container(
                  child: CustomTextInput(
                inputController: _driverNameController,
                titleText: "Driver's Name  :  ",
                isRequired: false,
                // buttonClickStatus: submitButtonClicked
              )),

              // Replace Vehicle Details----------------------------------------
              Container(
                margin: ApplicationMarginValues.replaceBoxMargin,
                decoration: const BoxDecoration(
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
                  title: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Replace Vehicle / Driver Details',
                      style: TextStyle(
                          fontSize:
                              ApplicationTextSizes.userInputFieldLabelValue,
                          fontFamily: 'Poppins',
                          fontWeight:
                              ApplicationTextWeights.UserInputsLabelWeight),
                    ),
                  ),

                  // controlAffinity: null,

                  // title: const Text(
                  //   'Replace Vehicle / Driver Details',
                  //   style: TextStyle(
                  //       fontSize: ApplicationTextSizes.userInputFieldLabelValue,
                  //       fontFamily: 'Poppins',
                  //       fontWeight:
                  //           ApplicationTextWeights.UserInputsLabelWeight),
                  // ),

                  trailing: GestureDetector(
                    onTap: () {},
                    child: CustomToggleButton(
                      changeToggleAction: toggleExpansion,
                    ),
                  ),

                  // trailing: CustomToggleButton(
                  //   changeToggleAction: toggleExpansion,
                  // ),

                  // trailing: IconButton(
                  //   icon: CustomToggleButton(
                  //     changeToggleAction: toggleExpansion,
                  //   ),
                  //   onPressed: () {},
                  // ),

                  // trailing: null,

                  children: <Widget>[
                    const ListTile(
                      title: Text(
                          'If a replacement driver or vehicle arrives, please fill in the following fields.',
                          style: TextStyle(
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight,
                            fontFamily: 'Poppins',
                            fontSize: ApplicationTextSizes.RememberMeTextValue,
                          )),
                    ),
                    CustomTextInput(
                      inputController: _replaceVehicleNumberController,
                      titleText: "Vehicle Number  :  ",
                      inputEnabled: _vehicleNumberController.text.isEmpty ||
                              _driverLicenseController.text.isEmpty
                          ? false
                          : true,
                      inputFormatters: <TextInputFormatter>[
                        VehicleNumberTextInputFormatter(),
                      ],
                      isRequired: true,
                      // buttonClickStatus: submitButtonClicked,
                    ),
                    CustomTextInput(
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
                      isRequired: true,
                      // buttonClickStatus: submitButtonClicked
                    ),
                    CustomTextInput(
                      inputController: _replaceCommentController,
                      titleText: 'Comments  :  ',
                      inputEnabled: _vehicleNumberController.text.isEmpty ||
                              _driverLicenseController.text.isEmpty
                          ? false
                          : true,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(100)
                      ],
                      isRequired: false,
                    ),
                  ],
                ),
              ),

              // Current Vehicle Mileage-------------------------------------
              // Container(
              //   margin: ApplicationMarginValues.pageInputFieldsMargin,
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         child: Row(
              //           children: [
              //             Text(
              //               "Current Vehicle Mileage  :  ",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   fontFamily: 'Poppins',
              //                   fontWeight: ApplicationTextWeights
              //                       .UserInputsLabelWeight),
              //             ),
              //             Text(
              //               "*",
              //               style: TextStyle(
              //                   fontSize: ApplicationTextSizes
              //                       .userInputFieldLabelValue,
              //                   color: ApplicationColors.RED_COLOR,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         margin: ApplicationMarginValues.textInputFieldInnerMargin,
              //         child: Column(
              //           children: <Widget>[
              //             Container(
              //               child: TextFormField(
              //                 // enabled: false,
              //                 controller: _currentMileageController,
              //                 keyboardType: TextInputType.number,
              //                 inputFormatters: <TextInputFormatter>[
              //                   FilteringTextInputFormatter.digitsOnly,
              //                   LengthLimitingTextInputFormatter(6)
              //                 ],
              //                 maxLength: 6,
              //                 decoration: InputDecoration(
              //                     filled: true,
              //                     fillColor: ApplicationColors.PURE_WHITE,
              //                     border: OutlineInputBorder(),
              //                     errorText: _currentMileageError),
              //               ),
              //             ),
              //             Container(
              //                 margin:
              //                     ApplicationMarginValues.mileageMarginValue,
              //                 child: Row(
              //                   children: [
              //                     CustomSelectorButton(
              //                       changeToggleAction: () {
              //                         Provider.of<MileageUnit>(context,
              //                                 listen: false)
              //                             .toggleUnit();
              //                       },
              //                     ),
              //                   ],
              //                 ))
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              Container(
                  child: CustomTextInput(
                inputController: _currentMileageController,
                titleText: 'Current Vehicle Mileage  :  ',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                keyboardType: TextInputType.number,
                isRequired: true,
                buttonClickStatus: submitButtonClicked,
              )),

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
                          setState(() {
                            submitButtonClicked = true;
                          });

                          setState(() {
                            combinedDateTime =
                                '${_dateController.text} ${_timeController.text}';
                          });
                          // submitButtonClicked = true;
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

                          //----------------------------------

                          // for (int i = 0;
                          //     i <
                          //         findAllVehiclesProvider
                          //             .findAllVehiclesResponse!
                          //             .appVehicleMobileDtoList!
                          //             .length;
                          //     i++) {
                          //       final driverDetails = findAllVehiclesProvider
                          //       .findAllVehiclesResponse!.appVehicleMobileDtoList![i];

                          //       logger.i('A 3');

                          //       if(_replaceDriverNICController.text.isEmpty) {
                          //         logger.i('A 4');
                          //         if(_driverLicenseController.text == driverDetails.driverDto!.licenseNum) {
                          //           logger.i('A 4.1');
                          //           driverID = driverDetails.id;
                          //         }
                          //         logger.i(driverID);
                          //       } else {
                          //         logger.i('A 5');
                          //         if(driverDetails.driverDto!.nic == _replaceDriverNICController.text) {
                          //           logger.i('A 5.1');
                          //           driverID = driverDetails.id;
                          //         }
                          //         logger.i(driverID);
                          //       }
                          //     }

                          //-----------------------------------------

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

                          //-----------------------------------------

                          // for (int i = 0;
                          //     i <
                          //         findAllDriversProvider.findAllDriversResponse!
                          //             .appDriverMobileDtoList.length;
                          //     i++) {
                          //   final driver = findAllDriversProvider
                          //       .findAllDriversResponse
                          //       ?.appDriverMobileDtoList[i];
                          //   if (driver?.licenseNum ==
                          //       _driverLicenseController.text) {
                          //     driverID = driver?.id;
                          //     _driverNameController.text = '${driver?.cname}';
                          //   } else if (driver?.nic ==
                          //       _replaceDriverNICController.text) {
                          //     driverID = driver?.id;
                          //     // _driverNameController.text = '${driver?.cname}';
                          //   }
                          // }

                          //------------------------------------------------

                          setState(() {
                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });

                          // checkFilledRequiredFields();
                          // checkFIlledAllFields();
                          // workInButton();
                          workInButtonDialogBox(context);
                        },
                        innerText: 'Work-In',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderWidth: 0.0,
                        // borderRadius: 4,
                        // buttonWidth: 200,
                        // buttonHeight: 45,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
                        // textStyles: TextStyle(
                        //   fontSize:
                        //       ApplicationTextSizes.userInputFieldLabelValue,
                        //   fontFamily: 'Poppins',
                        //   fontWeight:
                        //       ApplicationTextWeights.UserInputsLabelWeight,
                        //   color: ApplicationColors.PURE_WHITE,
                        // ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        onPress: () {
                          setState(() {
                            submitButtonClicked = true;
                          });
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

                          //----------------------------------------------------

                          // for (int i = 0;
                          //     i <
                          //         findAllDriversProvider.findAllDriversResponse!
                          //             .appDriverMobileDtoList.length;
                          //     i++) {
                          //   final driver = findAllDriversProvider
                          //       .findAllDriversResponse
                          //       ?.appDriverMobileDtoList[i];
                          //   if (driver?.licenseNum ==
                          //       _driverNameController.text) {
                          //     driverID = driver?.id;
                          //     _driverNameController.text = '${driver?.cname}';
                          //   } else if (driver?.nic ==
                          //       _replaceDriverNICController.text) {
                          //     driverID = driver?.id;
                          //     // _driverNameController.text = '${driver?.cname}';
                          //   }
                          // }

                          //-----------------------------------------------------

                          checkFilledRequiredFields();
                          checkFIlledAllFields();
                          workOutButton();
                        },
                        innerText: 'Work-Out',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderWidth: 0.0,
                        // borderRadius: 4,
                        // buttonWidth: 200,
                        // buttonHeight: 45,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
                        // textStyles: TextStyle(
                        //   fontSize:
                        //       ApplicationTextSizes.userInputFieldLabelValue,
                        //   fontFamily: 'Poppins',
                        //   fontWeight:
                        //       ApplicationTextWeights.UserInputsLabelWeight,
                        //   color: ApplicationColors.PURE_WHITE,
                        // ),
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
