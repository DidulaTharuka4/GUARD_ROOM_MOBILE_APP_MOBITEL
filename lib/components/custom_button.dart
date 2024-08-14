import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final String innerText;
  final Color backgroundColor;
  final VoidCallback onPress;
  final TextStyle textStyles;
  final double buttonWidth;
  final double buttonHeight;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const CustomButton(
      {Key? key,
      required this.innerText,
      required this.backgroundColor,
      required this.onPress,
      required this.textStyles,
      required this.buttonWidth,
      required this.buttonHeight,
      required this.borderColor,
      required this.borderWidth,
      required this.borderRadius})
      : super(key: key);

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
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(innerText, style: textStyles),
    );
  }
}
