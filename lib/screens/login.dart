import 'package:Guard_Room_Application/components/custom_button.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/providers/login_provider.dart';
import 'package:Guard_Room_Application/screens/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_alert_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
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
    final snackBar = SnackBar(
      content: Text('Error in login!'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccess(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Login Successfully !'),
      backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loginFailedDialogBox(BuildContext context) {
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

  void showCustomDialog(BuildContext context) {
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

  String? _usernameError;
  String? _passwordError;

  Future<void> checkFilled() async {
    setState(() {
      _usernameError =
          _usernameController.text.isEmpty ? 'Username cannot be empty' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    });

    if (_usernameController.text.isEmpty == false &&
        _passwordController.text.isEmpty == false) {
      // logger.i('password, usename filled');
      submitLogin();
    } else if (_usernameController.text.isEmpty == true &&
        _passwordController.text.isEmpty == true) {
      showCustomDialog(context);
    } else if (_usernameController.text.isEmpty == true &&
        _passwordController.text.isEmpty == false) {
      showCustomDialog(context);
    } else if (_usernameController.text.isEmpty == false &&
        _passwordController.text.isEmpty == true) {
      showCustomDialog(context);
    }
  }

  Map<String, dynamic> getLoginRequestBody(String? username, String? password) {
    return {
      'username': username,
      'password': password,
    };
  }

  void submitLogin() async {
    try {
      // await Provider.of<LoginProvider>(context, listen: false)
      //     .fetchLogin(_usernameController.text, _passwordController.text);

      await Provider.of<LoginProvider>(context, listen: false).fetchLogin(
          getLoginRequestBody(
              _usernameController.text, _passwordController.text));
    } catch (error) {
      logger.i(error);
    }

    LoginToMyAccount();
  }

  // bool isLoading = false;

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
                color: ApplicationColors.MAIN_COLOR_BLUE, strokeWidth: 4.0),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // Close the loading dialog
  }

  Future<void> LoginToMyAccount() async {
    final token = await getToken();
    // setState(() {
    //   isLoading = true;
    // });

    showLoadingDialog(context);

    await Future.delayed(Duration(seconds: 2));

    hideLoadingDialog(context);

    // setState(() {
    //   isLoading = false;
    // });

    if (token == null) {
      loginFailedDialogBox(context);
      // _passwordController.clear();
      // _usernameController.clear();
      // showError(context);
      logger.i('Login Failed !');
    } else {
      showSuccess(context);
      logger.i('Login Successfully !');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TypeSelector()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ApplicationColors.PURE_WHITE,
      body: SingleChildScrollView(
        child: Stack(
          // padding: EdgeInsets.all(0.0),
          children: [
            Column(
              children: <Widget>[
                // Header Color Container Part-----------------------------------
                Container(
                    child: SvgPicture.asset('assets/images/Footer.svg',
                        width: screenSize.width)),

                // Login Account page title-------------------------------------
                Container(
                  margin: ApplicationMarginValues.loginPageTitleMargin,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login Account',
                      style: TextStyle(
                          fontSize: ApplicationTextSizes.LoginPageTitleText,
                          fontWeight:
                              ApplicationTextWeights.PageTitleTextWeight,
                          fontFamily: 'Poppins',
                          color: ApplicationColors.LOGIN_TEXT_COLOR),
                    ),
                  ),
                ),

                // UserName Input Field------------------------------------------
                Container(
                  margin: ApplicationMarginValues.loginPageUserNameInputMargin,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username :',
                        style: TextStyle(
                            fontSize:
                                ApplicationTextSizes.UserInputFieldLabelValue,
                            fontFamily: 'Poppins',
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight),
                      ),
                    ),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 5.0)),
                          errorText: _usernameError,
                        ),
                      ),
                    ),
                  ]),
                ),

                // Password Input Field------------------------------------------
                Container(
                  margin: ApplicationMarginValues.userInputFiledMargin,
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password :',
                        style: TextStyle(
                            fontSize:
                                ApplicationTextSizes.UserInputFieldLabelValue,
                            fontFamily: 'Poppins',
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight),
                      ),
                    ),
                    Container(
                      margin: ApplicationMarginValues.textInputFieldInnerMargin,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorText: _passwordError,
                        ),
                        obscureText: true,
                      ),
                    ),
                  ]),
                ),

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
                            fontSize: ApplicationTextSizes.RememberMeTextValue,
                            fontFamily: 'Poppins',
                            fontWeight:
                                ApplicationTextWeights.UserInputsLabelWeight),
                      ),
                    ],
                  ),
                ),

                // Login Button---------------------------------------------------
                Container(
                  margin: ApplicationMarginValues.loginPageButtonMargin,
                  child: CustomButton(
                    onPress: () {
                      clearToken();
                      checkFilled();
                      _saveCredentials();
                      // logger.i(screenSize.height);
                      // logger.i(screenSize.width);
                    },
                    innerText: 'Login',
                    backgroundColor: ApplicationColors.MAIN_COLOR_BLUE,
                    borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                    borderWidth: 0.0,
                    borderRadius: 4,
                    buttonWidth: screenSize.width,
                    // buttonHeight: 54.024,
                    // buttonWidth: screenSize.width,
                    buttonHeight: screenSize.height / 16.47944802310084,
                    textStyles: TextStyle(
                      fontSize: ApplicationTextSizes.LoginButtonTitleValue,
                      fontWeight: ApplicationTextWeights.LoginButtonTitleWeight,
                      fontFamily: 'Poppins',
                      color: ApplicationColors.PURE_WHITE,
                    ),
                  ),
                ),

                // Logo-----------------------------------------------------
                Container(
                    // margin: ApplicationMarginValues.loginPageLogoMargin,
                    margin: EdgeInsets.fromLTRB(
                        20.0, screenSize.height / 5.94, 20.0, 0.0),
                    child: SvgPicture.asset('assets/images/SLTMobitel_Logo.svg',
                        // width: 90.7214,
                        // height: 46.1455,
                        width: screenSize.width / 4.5350,
                        height: screenSize.height / 19.2930)),
              ],
            ),
            // if (isLoading)
            //   Container(
            //     color: Colors.black.withOpacity(0.5),
            //     child: Center(
            //       child: CircularProgressIndicator(
            //           color: ApplicationColors.MAIN_COLOR_BLUE,
            //           strokeWidth: 4.0),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
