import 'package:flutter/material.dart';
import 'package:sample_flutter_application_1/components/custom_button.dart';
import 'package:sample_flutter_application_1/constraints/colors.dart';
import 'package:sample_flutter_application_1/constraints/textSizes.dart';

class AlertDialogBox extends StatelessWidget {
  final String alertDialogText;

  const AlertDialogBox({
    Key? key,
    required this.alertDialogText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      // height: 200.0,
      height: screenSize.height / 4.4514,
      decoration: BoxDecoration(
        color: ApplicationColors.BG_LIGHT_BLUE,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            alertDialogText,
            style: TextStyle(
                fontSize: ApplicationTextSizes.customAlertDialog,
                fontWeight: FontWeight.bold,
                color: ApplicationColors.PURE_BLACK),
          ),
        ),
        Container(
              margin: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
              child: CustomButton(
                onPress: () {
                  Navigator.of(context).pop(); 
                },
                innerText: 'Okay',
                backgroundColor: ApplicationColors.PURE_WHITE,
                borderColor: ApplicationColors.MAIN_COLOR_BLUE,
                  borderWidth: 0.0,
                borderRadius: 10,
                // buttonWidth: 150,
                // buttonHeight: 40,
                buttonWidth: screenSize.width / 2.7432,
                buttonHeight: screenSize.height / 22.2571,
                textStyles: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: ApplicationColors.PURE_BLACK),
              ),
            ),
      ]),
    );
  }
}
