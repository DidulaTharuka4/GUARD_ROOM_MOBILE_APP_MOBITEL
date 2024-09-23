import 'package:Guard_Room_Application/components/Buttons/main_button.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';

class AlertDialogBoxSelector extends StatelessWidget {
  final String alertDialogText;
  final VoidCallback pressForYesButton;

  const AlertDialogBoxSelector({
    Key? key,
    required this.alertDialogText,
    required this.pressForYesButton,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      // width: 390,
      // height: 180,
      width: screenSize.width / 1.0549,
      height: screenSize.height / 4.9460,
      decoration: BoxDecoration(
        color: ApplicationColors.PURE_WHITE,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            alertDialogText,
            style: TextStyle(
                fontSize: ApplicationTextSizes.customAlertDialogButton,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: ApplicationColors.PURE_BLACK),
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
            child: Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: CustomButton(
                  onPress: () {
                    Navigator.of(context).pop();
                  },
                  innerText: 'No',
                  backgroundColor: ApplicationColors.PURE_WHITE,
                  borderColor: ApplicationColors.BUTTON_COLOR_BLUE,
                  borderWidth: 1.0,
                  // borderRadius: 4,
                  buttonWidth: 150,
                  buttonHeight: 40,
                  // textStyles: TextStyle(
                  //     fontSize: 17,
                  //     fontWeight: FontWeight.bold,
                  //     color: ApplicationColors.BUTTON_COLOR_BLUE),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: CustomButton(
                  onPress: pressForYesButton,
                  innerText: 'Yes',
                  backgroundColor: ApplicationColors.BUTTON_COLOR_BLUE,
                  borderColor: ApplicationColors.BUTTON_COLOR_BLUE,
                  borderWidth: 0.0,
                  // borderRadius: 4,
                  // buttonWidth: 150,
                  // buttonHeight: 40,
                  buttonWidth: screenSize.width / 2.7432,
                  buttonHeight: screenSize.height / 22.2571,
                  // textStyles: TextStyle(
                  //     fontSize: 17,
                  //     fontWeight: FontWeight.bold,
                  //     color: ApplicationColors.PURE_WHITE),
                ),
              ),
              SizedBox(width: 10),
              
            ])),
      ]),
    );
  }
}
