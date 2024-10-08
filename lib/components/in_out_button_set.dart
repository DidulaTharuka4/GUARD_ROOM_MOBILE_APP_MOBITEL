import 'package:Guard_Room_Application/components/buttons/main_button.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:flutter/material.dart';

class ButtonSet extends StatelessWidget {
  final VoidCallback leftButtonOnPress;
  final VoidCallback rightButtonOnPress;
  final String leftButtonTitle;
  final String rightButtonTitle;

  const ButtonSet(
      {super.key,
      required this.leftButtonOnPress,
      required this.rightButtonOnPress,
      required this.leftButtonTitle,
      required this.rightButtonTitle});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      margin: ApplicationMarginValues.bottomButtonMargin,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CustomButton(
              onPress: leftButtonOnPress,
              innerText: leftButtonTitle,
              backgroundColor: ApplicationColors.BUTTON_COLOR_GREEN,
              borderColor: ApplicationColors.BUTTON_COLOR_GREEN,
              // borderRadius: 4,
              // buttonWidth: 200,
              // buttonHeight: 45,
              buttonWidth: screenSize.width / 2.0571,
              buttonHeight: screenSize.height / 19.7841,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: CustomButton(
              onPress: rightButtonOnPress,
              innerText: rightButtonTitle,
              backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
              borderColor: ApplicationColors.MAIN_COLOR_BLUE,
              // borderRadius: 4,
              // buttonWidth: 200,
              // buttonHeight: 45,
              buttonWidth: screenSize.width / 2.0571,
              buttonHeight: screenSize.height / 19.7841,
            ),
          ),
        ],
      ),
    );
  }
}
