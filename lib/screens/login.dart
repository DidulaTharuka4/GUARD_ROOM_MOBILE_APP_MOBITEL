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
// import 'package:sample_flutter_application_1/constraints/marginValues.dart';
// import 'package:sample_flutter_application_1/constraints/textSizes.dart';
// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/providers/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sample_flutter_application_1/screens/type_selector.dart';
// import 'package:sample_flutter_application_1/components/custom_alert_dialog.dart';
// import 'package:sample_flutter_application_1/components/custom_button.dart';
// import 'package:sample_flutter_application_1/constraints/colors.dart';

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
      // print('password, usename filled');
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

  // final token = getToken();

  // final _formKey = GlobalKey<FormState>();

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
      // print(error);
    }

    LoginToMyAccount();
  }

  Future<void> LoginToMyAccount() async {
    final token = await getToken();

    if (token == null) {
      showError(context);
      logger.i('Login Failed !');
    } else {
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
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0.0),
          child: Column(
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
                        fontWeight: ApplicationTextWeights.PageTitleTextWeight,
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
                    // submitLogin();
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
                  margin: ApplicationMarginValues.loginPageLogoMargin,
                  child: SvgPicture.asset(
                      'assets/images/SLTMobitel_Logo.svg',
                      // width: 90.7214,
                      // height: 46.1455,
                      width: screenSize.width / 4.5350,
                      height: screenSize.height / 19.2930)),
            ],
          ),
        ),
      ),
    );
  }
}
