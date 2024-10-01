import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final String innerText;
  final Color backgroundColor;
  final VoidCallback onPress;
  // final TextStyle textStyles;
  final double buttonWidth;
  final double buttonHeight;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  // final double borderRadius;

  const CustomButton({
    Key? key,
    required this.innerText,
    required this.backgroundColor,
    required this.onPress,
    // required this.textStyles,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.borderColor,
    this.borderWidth = 0.0,
    this.textColor = ApplicationColors.PURE_WHITE,
    // required this.borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(buttonWidth, buttonHeight),
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(innerText,
          style: TextStyle(
            color: textColor,
            fontSize: ApplicationTextSizes.LoginButtonTitleValue,
            fontWeight: ApplicationTextWeights.LoginButtonTitleWeight,
            fontFamily: 'Poppins',
          )),
    );
  }
}
