import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  // Initialize the screen size using MediaQuery
  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  // Calculate font size based on screen width or height
  static double setFontSize(double size) {
    return blockSizeHorizontal * (size / 4);
  }
}

class ApplicationTextSizes {
  // static const attendancePageButtonTitle = 25.0;
  static double attendancePageButtonTitle(BuildContext context) =>
      SizeConfig.setFontSize(25.0);

  // static const userInputFieldLabelValue = 18.0;
  static double userInputFieldLabelValue(BuildContext context) =>
      SizeConfig.setFontSize(18.0);

  // static const provinceDropdownTitle = 12.0;
  static double provinceDropdownTitle(BuildContext context) =>
      SizeConfig.setFontSize(12.0);

  // static const customAlertDialogButton = 16.0;
  static double customAlertDialogButton(BuildContext context) =>
      SizeConfig.setFontSize(16.0);

  // static const customAlertDialog = 24.0;
  static double customAlertDialog(BuildContext context) =>
      SizeConfig.setFontSize(24.0);


//----------------------------------------------------------------------------

  // static const LoginPageTitleText = 27.012;
  static double LoginPageTitleText(BuildContext context) =>
      SizeConfig.setFontSize(27.012);

  // static const UserInputFieldLabelValue = 18.0;
  static double UserInputFieldLabelValue(BuildContext context) =>
      SizeConfig.setFontSize(18.0);

  // static const RememberMeTextValue = 13.506;
  static double RememberMeTextValue(BuildContext context) =>
      SizeConfig.setFontSize(13.506);

  // static const LoginButtonTitleValue = 18.0;
  static double LoginButtonTitleValue(BuildContext context) =>
      SizeConfig.setFontSize(18.0);

  // static const pageTitleTextValue = 20.0;
  static double pageTitleTextValue(BuildContext context) =>
      SizeConfig.setFontSize(20.0);


//---------------------------------------------------------------------------------------

  // static const TypeSelectotPageTitle = 23.0;
  static double TypeSelectotPageTitle(BuildContext context) =>
      SizeConfig.setFontSize(23.0);
      
  // static const SelectorButtonTitleValue = 24.0;
  static double SelectorButtonTitleValue(BuildContext context) =>
      SizeConfig.setFontSize(24.0);

  // static const FInalResponseAlertTextTitle = 20.0;
  static double FInalResponseAlertTextTitle(BuildContext context) =>
      SizeConfig.setFontSize(20.0);

  // static const FInalResponseAlertText = 14.0;
  static double FInalResponseAlertText(BuildContext context) =>
      SizeConfig.setFontSize(14.0);
}

class ApplicationTextWeights {
  static const PageTitleTextWeight = FontWeight.w600;
  static const UserInputsLabelWeight = FontWeight.w400;
  static const LoginButtonTitleWeight = FontWeight.w500;
}
