import 'dart:async';
// import 'package:Guard_Room_Application/components/alert_boxes.dart';
import 'package:Guard_Room_Application/components/alert_boxes/invalid_input_alert_box.dart';
import 'package:Guard_Room_Application/components/alert_boxes/confirmation_alert_box.dart';
import 'package:Guard_Room_Application/components/buttons/main_button.dart';
import 'package:Guard_Room_Application/components/buttons/custom_selector_button.dart';
import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/driver_dropdown.dart';
import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/driver_list.dart';
import 'package:Guard_Room_Application/components/all_alert_boxes.dart';
import 'package:Guard_Room_Application/components/main_text_input.dart';
import 'package:Guard_Room_Application/components/buttons/toggle_button.dart';
// import 'package:Guard_Room_Application/components/alert_boxes/success_error_alert_box.dart';
import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/vehicle_dropdown.dart';
import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/vehicle_list.dart';
import 'package:Guard_Room_Application/components/top_banner.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/notifiers/mileage_unit.dart';
import 'package:Guard_Room_Application/providers/end_attendance_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/providers/start_attendance_provider.dart';
import 'package:Guard_Room_Application/components/app_bars/form_page_appbar.dart';
import 'package:Guard_Room_Application/providers/vehicle_in_provider.dart';
import 'package:Guard_Room_Application/providers/vehicle_out_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum ButtonType {
  workIn,
  workOut,
  empty,
}

enum RecordType {
  vehicleIn,
  vehicleOut,
}

enum ApiRequestType {
  vehicleInWithTemp,
  vehicleInWithoutTemp,
  vehicleOutWithTemp,
  vehicleOutWithoutTemp,
}

class DailyTrip extends StatefulWidget {
  @override
  _DailyTrip createState() => _DailyTrip();
}

class _DailyTrip extends State<DailyTrip> {
  // final TextEditingController _currentDateController = TextEditingController();
  final TextEditingController _tripIDController = TextEditingController();
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

  final List<TextEditingController> allControllers = [];

  ButtonType currentButtonState = ButtonType.empty;

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

  @override
  void initState() {
    super.initState();
    startClock();
    getCurrentDate();
    allControllers.add(_tripIDController);
    allControllers.add(_vehicleNumberController);
    allControllers.add(_driverLicenseController);
    allControllers.add(_driverNameController);
    allControllers.add(_currentMileageController);
    allControllers.add(_replaceDriverNICController);
    allControllers.add(_replaceVehicleNumberController);
    allControllers.add(_replaceCommentController);

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

  void clearAndDisposeControllers() {
    // Clear the text fields first (optional)
    allControllers.forEach((controller) {
      controller.clear();
      // controller.dispose();
    });

    // Clear the list of controllers
    // allControllers.clear();
  }

  @override
  void dispose() {
    timer.cancel();
    _timeController.dispose();
    allControllers.forEach((controller) {
      controller.dispose();
    });
    // clearAndDisposeControllers();
    super.dispose();
  }

  String getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  // real time updating clock and timer function------------------------------
  void startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        return const AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(),
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
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
    Navigator.of(context).pop();
  }

  void mainButtonPress(RecordType recordType) {
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context, listen: false);
    final findAllDriversProvider =
        Provider.of<FindAllDriversProvider>(context, listen: false);
    // final loginProvider = Provider.of<LoginProvider>(context);
    // setState(() {
    //   submitButtonClicked = true;
    // });

    // setState(() {
    //   userID = loginProvider.loginresponse!.loginDetailsDto.userId;
    //   userName = loginProvider.loginresponse!.loginDetailsDto.userName;
    // });
    logger.i('lll');

    combinedDateTime = '${_dateController.text} ${_timeController.text}';
    logger.i(combinedDateTime);

    Provider.of<MileageUnit>(context, listen: false)
        .mileageToggleButton(_currentMileageController.text);

    final vehicle = findAllVehiclesProvider
        .findAllVehiclesResponse?.appVehicleMobileDtoList;

    vehicleID = vehicle
        ?.firstWhere(
          (vehicle) => _replaceVehicleNumberController.text.isEmpty
              ? vehicle.vehicleRegNumber == _vehicleNumberController.text
              : vehicle.vehicleRegNumber ==
                  _replaceVehicleNumberController.text,
          // orElse: () => null,
        )
        .id;

    logger.i('A 2');
    logger.i(vehicleID);

    final driver =
        findAllDriversProvider.findAllDriversResponse!.appDriverMobileDtoList;

    driverID = driver
        .firstWhere(
          (driver) => _replaceDriverNICController.text.isEmpty
              ? driver.licenseNum == _driverLicenseController.text
              : driver.nic == _replaceDriverNICController.text,
          // orElse: () => null,
        )
        .id;
    logger.i('B2');
    logger.i(driverID);

    if (_vehicleNumberController.text.isNotEmpty == true &&
        _currentMileageController.text.isNotEmpty == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0.0),
            content: AlertDialogBoxSelector(
                pressForYesButton: () {
                  // if (userID != null) {
                  //   if (_replaceDriverNICController.text.isEmpty == true &&
                  //       _replaceVehicleNumberController.text.isEmpty == true) {
                  //     setApiRequest(ApiRequestType.vehicleInWithoutTemp);
                  //   } else {
                  //     setApiRequest(ApiRequestType.vehicleInWithTemp);
                  //   }
                  // } else {
                  //   if (_replaceDriverNICController.text.isEmpty == true &&
                  //       _replaceVehicleNumberController.text.isEmpty == true) {
                  //     setApiRequest(ApiRequestType.vehicleOutWithoutTemp);
                  //   } else {
                  //     setApiRequest(ApiRequestType.vehicleOutWithTemp);
                  //   }
                  // }

                  logger.i('mh1');

                  switch (recordType) {
                    case RecordType.vehicleIn:
                      if (_replaceDriverNICController.text.isEmpty == true &&
                          _replaceVehicleNumberController.text.isEmpty ==
                              true) {
                        setApiRequest(ApiRequestType.vehicleInWithoutTemp);
                      } else {
                        setApiRequest(ApiRequestType.vehicleInWithTemp);
                      }
                      break;

                    case RecordType.vehicleOut:
                      if (_replaceDriverNICController.text.isEmpty == true &&
                          _replaceVehicleNumberController.text.isEmpty ==
                              true) {
                        setApiRequest(ApiRequestType.vehicleOutWithoutTemp);
                      } else {
                        setApiRequest(ApiRequestType.vehicleOutWithTemp);
                      }
                      break;
                  }

                  // endWithWithoutSelector();
                  Navigator.of(context).pop();
                  showLoadingDialog(context);
                },
                alertDialogText:
                    'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text}:  ?'),
          );
        },
      );
    }

    // workInOutButtonDialogBox(context);
  }

  // void workInOutButtonDialogBox(BuildContext context) {
  //   if (_vehicleNumberController.text.isNotEmpty == true &&
  //       _currentMileageController.text.isNotEmpty == true) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           contentPadding: const EdgeInsets.all(0.0),
  //           content: AlertDialogBoxSelector(
  //               pressForYesButton: () {
  //                 if (userID != null) {
  //                   if (_replaceDriverNICController.text.isEmpty == true &&
  //                       _replaceVehicleNumberController.text.isEmpty == true) {
  //                     setApiRequest(ApiRequestType.vehicleInWithoutTemp);
  //                   } else {
  //                     setApiRequest(ApiRequestType.vehicleInWithTemp);
  //                   }
  //                 } else {
  //                   if (_replaceDriverNICController.text.isEmpty == true &&
  //                       _replaceVehicleNumberController.text.isEmpty == true) {
  //                     setApiRequest(ApiRequestType.vehicleOutWithoutTemp);
  //                   } else {
  //                     setApiRequest(ApiRequestType.vehicleOutWithTemp);
  //                   }
  //                 }

  //                 // endWithWithoutSelector();
  //                 Navigator.of(context).pop();
  //                 showLoadingDialog(context);
  //               },
  //               alertDialogText:
  //                   'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text}:  ?'),
  //         );
  //       },
  //     );
  //   }
  // }

  //--------------------------------------------------------
  void setApiRequest(ApiRequestType requestType) async {
    Map<String, dynamic> vehicleInOutRecordDto = {};

    // Common parts
    vehicleInOutRecordDto['vehicleId'] = vehicleID;
    vehicleInOutRecordDto['driverId'] = driverID;
    vehicleInOutRecordDto['recordTime'] = combinedDateTime;
    vehicleInOutRecordDto['addedBy'] = userID;
    vehicleInOutRecordDto['officer'] = userName;
    vehicleInOutRecordDto['tripId'] = _tripIDController.text;
    vehicleInOutRecordDto['mileage'] = _currentMileageController.text;

    // Customize parts
    switch (requestType) {
      case ApiRequestType.vehicleInWithTemp:
        vehicleInOutRecordDto['tempVehicleNo'] =
            _replaceVehicleNumberController.text;
        vehicleInOutRecordDto['tempDriverNic'] =
            _replaceDriverNICController.text;

        vehicleInOutRecordDto['comment'] = _replaceCommentController.text;

        vehicleInOutRecordDto['type'] = 'IN';

        break;

      case ApiRequestType.vehicleInWithoutTemp:
        vehicleInOutRecordDto['comment'] = 'No comments';

        vehicleInOutRecordDto['type'] = 'IN';

        break;

      case ApiRequestType.vehicleOutWithTemp:
        vehicleInOutRecordDto['tempVehicleNo'] =
            _replaceVehicleNumberController.text;
        vehicleInOutRecordDto['tempDriverNic'] =
            _replaceDriverNICController.text;

        vehicleInOutRecordDto['comment'] = 'No comments';

        vehicleInOutRecordDto['type'] = 'OUT';

        break;

      case ApiRequestType.vehicleOutWithoutTemp:
        vehicleInOutRecordDto['comment'] = 'Out comments';

        vehicleInOutRecordDto['type'] = 'OUT';

        break;
    }

    Map<String, dynamic> requestBody = {
      'vehicleInOutRecordDto': vehicleInOutRecordDto
    };

    try {
      // Call the relevant API method based on the request type
      switch (requestType) {
        case ApiRequestType.vehicleInWithTemp:
          await Provider.of<VehicleInProvider>(context, listen: false)
              .VehicleInWIthTemp(requestBody);
          break;

        case ApiRequestType.vehicleInWithoutTemp:
          await Provider.of<VehicleInProvider>(context, listen: false)
              .VehicleInWithoutTemp(requestBody);
          break;

        case ApiRequestType.vehicleOutWithTemp:
          await Provider.of<VehicleOutProvider>(context, listen: false)
              .VehicleOutWithTemp(requestBody);
          break;

        case ApiRequestType.vehicleOutWithoutTemp:
          await Provider.of<VehicleOutProvider>(context, listen: false)
              .VehicleOutWithoutTemp(requestBody);
          break;
      }
    } catch (error) {
      logger.i('Error occurred in API request: $error');
    }

    // Show loading dialog and handle success
    // showLoadingDialog(context);
    // await Future.delayed(const Duration(seconds: 2));
    // hideLoadingDialog(context);

    successCall();
    setState(() {
      vehicleID = null;
    });
  }

  //--------------------------------------------------------

  void successCall() {
    // final startAttendanceProvider =
    //     Provider.of<StartAttendanceProvider>(context, listen: false);

    // final endAttendanceProvider =
    //     Provider.of<EndAttendanceProvider>(context, listen: false);

        final vehicleInProvider =
        Provider.of<VehicleInProvider>(context, listen: false);

        final vehicleOutProvider =
        Provider.of<VehicleOutProvider>(context, listen: false);

    logger.i('1 ');

    if (vehicleInProvider.vehicleInWithTempResponse?.success ==
            true ||
        vehicleInProvider.vehicleInWithoutTempResponse?.success ==
            true ||
        vehicleOutProvider.vehicleOutWithTempResponse?.success ==
            true ||
        vehicleOutProvider.vehicleOutWithoutTempResponse?.success == true) {
      successStatus = true;
    } else {
      successStatus = false;
    }

    hideLoadingDialog(context);

    finalResponseStatusDialogBox(context, successStatus!);

    // Navigator.pop(context);
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

  // content design------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ApplicationColors.PURE_WHITE,
      statusBarIconBrightness: Brightness.dark,
    ));
    var screenSize = MediaQuery.of(context).size;
    // final findAllVehiclesProvider =
    //     Provider.of<FindAllVehiclesProvider>(context);
    // final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final vehicleListProvider = Provider.of<VehicleListProvider>(context);
    final licenseNumberListProvider =
        Provider.of<LicenseNumberListProvider>(context);
    final topBannerOne =
        const TopBanner(message: "This is a top banner notification!");
    return Scaffold(
        backgroundColor: ApplicationColors.PURE_WHITE,
        appBar: FormPageAppBarWithShadow(
          pageTitle: 'Daily Trips',
          pressForClear: () {
            clearAndDisposeControllers();
          },
        ),
        body: Container(
          // margin: ApplicationMarginValues.pageContainerMargin,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(children: <Widget>[
              Container(
                  margin: ApplicationMarginValues.formPageTopMargin,
                  child: CustomTextInput(
                    inputController: _dateTimeController,
                    titleText: "Date  :  ",
                    inputEnabled: false,
                    isRequired: false,
                  )),

              CustomTextInput(
                inputController: _tripIDController,
                titleText: 'Trip ID  :  ',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.number,
                isRequired: true,
                buttonClickStatus: submitButtonClicked,
              ),

              CustomTextInput(
                  inputController: _vehicleNumberController,
                  titleText: "Vehicle Number  :  ",
                  inputFormatters: [
                    VehicleNumberTextInputFormatter(),
                    LengthLimitingTextInputFormatter(8)
                  ],
                  onTap: () {
                    // topBannerOne.showBanner(context);

                    // ScaffoldMessenger.of(context).showMaterialBanner(
                    //   MaterialBanner(
                    //     padding: EdgeInsets.all(10),
                    //     content: Text('Hello, I am a Material Banner'),
                    //     leading: Icon(Icons.agriculture_outlined),
                    //     backgroundColor: ApplicationColors.BACKGROUND_BLUE,
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () {
                    //           ScaffoldMessenger.of(context)
                    //               .hideCurrentMaterialBanner();
                    //         },
                    //         child: Text('DISMISS'),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                  onChange: (value) {
                    vehicleListProvider.filterVehicles(context, value);
                  },
                  inputEnabled:
                      _vehicleNumberController.text.isEmpty ? true : false,
                  isRequired: true,
                  buttonClickStatus: submitButtonClicked),

              VehicleDropdown(
                vehicleNumberController: _vehicleNumberController,
                driverLicenseController: _driverLicenseController,
                driverNameController: _driverNameController,
                onVehicleSelected: (selectedVehicle) {
                  setState(() {
                    vehicleListProvider.showDropdown = false;
                  });
                },
              ),

              CustomTextInput(
                  inputController: _driverLicenseController,
                  titleText: "Driver's License Number  :  ",
                  // inputTextError: _licenseNumberError,
                  inputFormatters: [
                    DriverLicenseTextInputFormatter(),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  onChange: (value) {
                    licenseNumberListProvider.filterLicenseNumbers(
                        context, value);
                    // licenseNumberList();
                    // filterLicenseNumbers(value);
                  },
                  inputEnabled:
                      _driverLicenseController.text.isEmpty ? true : false,
                  isRequired: true,
                  buttonClickStatus: submitButtonClicked),

              LicenseNumberDropdown(
                vehicleNumberController: _vehicleNumberController,
                driverLicenseController: _driverLicenseController,
                driverNameController: _driverNameController,
                onDriverSelected: (selectedVehicle) {
                  setState(() {
                    licenseNumberListProvider.showLicenseNumberDropdown = false;
                  });
                },
              ),

              CustomTextInput(
                inputController: _driverNameController,
                titleText: "Driver's Name  :  ",
                isRequired: false,
                inputEnabled: false,
                // buttonClickStatus: submitButtonClicked
              ),

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

              CustomTextInput(
                inputController: _currentMileageController,
                titleText: 'Current Vehicle Mileage  :  ',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                keyboardType: TextInputType.number,
                isRequired: true,
                buttonClickStatus: submitButtonClicked,
              ),

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

              // Vehicle In vehicle Out Buttons----------------------------------------
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

                            userID = loginProvider
                                .loginresponse!.loginDetailsDto.userId;
                            userName = loginProvider
                                .loginresponse!.loginDetailsDto.userName;
                          });

                          // setState(() {
                          //   userID = loginProvider
                          //       .loginresponse!.loginDetailsDto.userId;
                          //   userName = loginProvider
                          //       .loginresponse!.loginDetailsDto.userName;
                          // });
                          logger.i('mmmm');

                          mainButtonPress(RecordType.vehicleIn);
                        },
                        innerText: 'Start',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
                        borderWidth: 0.0,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        onPress: () {
                          setState(() {
                            submitButtonClicked = true;
                          });

                          userID = loginProvider
                              .loginresponse!.loginDetailsDto.userId;
                          userName = loginProvider
                              .loginresponse!.loginDetailsDto.userName;

                          // setState(() {
                          //   userID = loginProvider
                          //       .loginresponse!.loginDetailsDto.userId;
                          //   userName = loginProvider
                          //       .loginresponse!.loginDetailsDto.userName;
                          // });

                          mainButtonPress(RecordType.vehicleOut);
                        },
                        innerText: 'End',
                        backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                        borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderWidth: 0.0,
                        buttonWidth: screenSize.width / 2.0571,
                        buttonHeight: screenSize.height / 19.7841,
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
