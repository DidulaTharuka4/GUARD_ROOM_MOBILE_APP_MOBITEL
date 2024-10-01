import 'package:Guard_Room_Application/components/buttons/main_button.dart';
import 'package:Guard_Room_Application/components/main_text_input.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
// import 'package:Guard_Room_Application/screens/loadingScreen.dart';
import 'package:Guard_Room_Application/components/app_bars/login_appbar.dart';
import 'package:Guard_Room_Application/screens/type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/alert_boxes/invalid_input_alert_box.dart';
// import 'dart:io'; // To use exit(0)

// import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  var logger = Logger();

  late String? svgContent;

  bool submitButtonClicked = false;

  // late Future<void> svgLoading;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    // Future.delayed(Duration(seconds: 5));
    loadSvgAssets();
  }

  Future<void> loadSvgAssets() async {
  
    svgContent = await DefaultAssetBundle.of(context)
        .loadString('assets/images/Footer.svg');
    setState(() {});
  }

  // Remember me function
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = (prefs.getBool('remember_me') ?? false);
      if (_rememberMe) {
        _usernameController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // Remember me function
  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
    }
    await prefs.setBool('remember_me', _rememberMe);
  }

  void showError(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Error in login!'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccess(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Login Successfully !',
        style: TextStyle(color: ApplicationColors.MAIN_COLOR_BLUE),
      ),
      backgroundColor: ApplicationColors.BG_LIGHT_BLUE,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loginFailedDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(
              // alertDialogText:
              //     'Cannot proceed with invalid inputs! Please try again.'
              ),
        );
      },
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(
              // alertDialogText:
              //     'Cannot proceed with invalid inputs! Please try again.'
              ),
        );
      },
    );
  }

  String? _usernameError;
  String? _passwordError;

  // Future<void> checkFilled() async {
  //   showLoadingDialog(context);
  //   setState(() {
  //     _usernameError =
  //         _usernameController.text.isEmpty ? 'Username cannot be empty' : null;
  //     _passwordError =
  //         _passwordController.text.isEmpty ? 'Password cannot be empty' : null;
  //   });

  //   if (_usernameController.text.isEmpty == false &&
  //       _passwordController.text.isEmpty == false) {
  //     // logger.i('password, usename filled');
  //     submitLogin();
  //   } else if (_usernameController.text.isEmpty == true &&
  //       _passwordController.text.isEmpty == true) {
  //     showCustomDialog(context);
  //   } else if (_usernameController.text.isEmpty == true &&
  //       _passwordController.text.isEmpty == false) {
  //     showCustomDialog(context);
  //   } else if (_usernameController.text.isEmpty == false &&
  //       _passwordController.text.isEmpty == true) {
  //     showCustomDialog(context);
  //   }
  // }

  Map<String, dynamic> getLoginRequestBody(String? username, String? password) {
    return {
      'username': username,
      'password': password,
    };
  }

  void submitLogin() async {
    showLoadingDialog(context);
    // await Future.delayed(const Duration(seconds: 1));
    try {
      await Provider.of<LoginProvider>(context, listen: false).fetchLogin(
          getLoginRequestBody(
              _usernameController.text, _passwordController.text));
    } catch (error) {
      logger.i(error);
    }
    // showLoadingDialog(context);
    loginToMyAccount();
  }

  Future<void> loginToMyAccount() async {
    final token = await getToken();

    // showLoadingDialog(context);

    // LoadingScreen();

    // await Future.delayed(const Duration(seconds: 2));

    hideLoadingDialog(context);

    if (token == null) {
      // hideLoadingDialog(context);
      loginFailedDialogBox(context);
      // _passwordController.clear();
      // _usernameController.clear();
      // showError(context);
      logger.i('Login Failed !');
    } else {
      // hideLoadingDialog(context);
      showSuccess(context);
      logger.i('Login Successfully !');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TypeSelector()),
        (Route<dynamic> route) => false,
      );
    }
  }

  // bool isLoading = false;

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        //   statusBarIconBrightness: Brightness.light,
        // ));
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            // child: CircularProgressIndicator(
            //     color: ApplicationColors.MAIN_COLOR_BLUE, strokeWidth: 4.0),

            child: CupertinoActivityIndicator(
                color: ApplicationColors.MAIN_COLOR_BLUE, radius: 30.0),

            // child: LinearProgressIndicator(
            //     value:
            //         null, // null for infinite loading, or a value between 0.0 and 1.0 for determinate
            //     backgroundColor: ApplicationColors
            //         .PURE_WHITE, // Background color of the progress bar
            //     color: ApplicationColors
            //         .MAIN_COLOR_BLUE // Color of the progress bar
            //     ),

            //     child: SpinKitWave(
            //   color: ApplicationColors.MAIN_COLOR_BLUE,
            //   size: 70.0,
            //   itemCount: 6
            // )
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the loading dialog
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    var screenSize = MediaQuery.of(context).size;
    Future.delayed(Duration(seconds: 3));
    return WillPopScope(
        onWillPop: () async {
          // Exit the app when the back button is pressed
          SystemNavigator.pop();
          return false; // Returning false prevents the usual behavior
        },
        child: Scaffold(
          backgroundColor: ApplicationColors.PURE_WHITE,
          appBar: const LoginPageAppBar(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(0.0),
            child: Stack(
              // padding: EdgeInsets.all(0.0),
              children: [
                Column(
                  children: <Widget>[
                    // Login Account page title-------------------------------------
                    Container(
                      margin: ApplicationMarginValues.loginPageTitleMargin,
                      child: Column(children: <Widget>[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login Account',
                            style: TextStyle(
                                fontSize:
                                    ApplicationTextSizes.LoginPageTitleText,
                                fontWeight:
                                    ApplicationTextWeights.PageTitleTextWeight,
                                fontFamily: 'Poppins',
                                color: ApplicationColors.LOGIN_TEXT_COLOR),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              // width: 220.0,
                              // height: 2.0,
                              width: screenSize.width / 1.92,
                              height: screenSize.height / 325.14,
                              child: Container(
                                color: ApplicationColors.LINE_GREEN,
                              ),
                            ))
                      ]),
                    ),

                    // UserName Input Field------------------------------------------
                    // Container(
                    //   margin: ApplicationMarginValues.loginPageUserNameInputMargin,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Username',
                    //         style: TextStyle(
                    //           fontSize:
                    //               ApplicationTextSizes.UserInputFieldLabelValue,
                    //           fontFamily: 'Poppins',
                    //           fontWeight:
                    //               ApplicationTextWeights.UserInputsLabelWeight,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 8.0),
                    //         child: TextFormField(
                    //           controller: _usernameController,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(),
                    //             errorText: _usernameError,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Container(
                        margin: ApplicationMarginValues
                            .loginPageUserNameInputMargin,
                        child: CustomTextInput(
                          inputController: _usernameController,
                          titleText: "Username :",
                          isRequired: false,
                          buttonClickStatus: submitButtonClicked,
                        )),

                    Container(
                        margin: ApplicationMarginValues
                            .loginPageUserNameInputMargin,
                        child: CustomTextInput(
                            inputController: _passwordController,
                            titleText: "Password :",
                            isRequired: false,
                            obscureText: true,
                            buttonClickStatus: submitButtonClicked)),

                    // Password Input Field------------------------------------------
                    // Container(
                    //   margin: ApplicationMarginValues.loginPageUserNameInputMargin,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Password',
                    //         style: TextStyle(
                    //           fontSize:
                    //               ApplicationTextSizes.UserInputFieldLabelValue,
                    //           fontFamily: 'Poppins',
                    //           fontWeight:
                    //               ApplicationTextWeights.UserInputsLabelWeight,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 8.0),
                    //         child: TextFormField(
                    //           controller: _passwordController,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(),
                    //             errorText: _passwordError,
                    //           ),
                    //           obscureText: true,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Remember Login-----------------------------------------------
                    Container(
                      margin: ApplicationMarginValues.rememberMeFieldMargin,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                fontSize:
                                    ApplicationTextSizes.RememberMeTextValue,
                                fontFamily: 'Poppins',
                                fontWeight: ApplicationTextWeights
                                    .UserInputsLabelWeight),
                          ),
                        ],
                      ),
                    ),

                    // Login Button---------------------------------------------------
                    Container(
                      margin: ApplicationMarginValues.loginPageButtonMargin,
                      child: CustomButton(
                        onPress: () {
                          setState(() {
                            submitButtonClicked = true;
                          });
                          submitButtonClicked = true;
                          clearToken();
                          submitLogin();
                          // checkFilled();
                          _saveCredentials();
                          // logger.i(screenSize.height);
                          // logger.i(screenSize.width);
                        },
                        innerText: 'Login',
                        backgroundColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                        borderWidth: 0.0,
                        buttonWidth: screenSize.width,
                        // buttonHeight: 54.024,
                        // buttonWidth: screenSize.width,
                        buttonHeight: screenSize.height / 16.47944802310084,
                      ),
                    ),

                    // Logo-----------------------------------------------------
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            20.0, screenSize.height / 5.94, 20.0, 0.0),
                        child: SvgPicture.asset(
                            'assets/images/SLTMobitel_Logo.svg',
                            // width: 90.7214,
                            // height: 46.1455,
                            width: screenSize.width / 4.5350,
                            height: screenSize.height / 19.2930)),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
