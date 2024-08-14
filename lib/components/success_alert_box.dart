import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessStatusAlertBox extends StatelessWidget {
  final bool successStatus;

  const SuccessStatusAlertBox({
    Key? key,
    required this.successStatus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 1.0549,
      height: screenSize.height / 4.9460,
      // width: 390,
      // height: 180,
      decoration: BoxDecoration(
        color: successStatus
            ? ApplicationColors.CUSTOM_SUCCESS_ALERT_BOX
            : ApplicationColors.CUSTOM_ERROR_ALERT_BOX,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: successStatus
              ? ApplicationColors.LINE_GREEN
              : ApplicationColors.RED_COLOR,
          width: 1,
        ),
      ),
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: SvgPicture.asset(
            successStatus? 'assets/images/sucess.svg' : 'assets/images/warning.svg',
              width: screenSize.width / 9.3506,
              height: screenSize.width / 9.3506
              // width: 44,
              // height: 44
            ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            successStatus ? 'Saved Successfully' : 'Failed to Save',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ApplicationTextSizes.FInalResponseAlertTextTitle,
              fontWeight: ApplicationTextWeights.PageTitleTextWeight,
              fontFamily: 'Poppins',
              color: successStatus
                  ? ApplicationColors.LINE_GREEN
                  : ApplicationColors.RED_COLOR,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            successStatus
                ? 'Your items have been successfully saved. Please rest assured that all the necessary information has been securely stored.'
                : 'We encountered an issue while attempting to save your items. Please try again, or contact support if the problem persists.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: ApplicationTextSizes.FInalResponseAlertText,
                fontWeight: ApplicationTextWeights.UserInputsLabelWeight,
                fontFamily: 'Poppins',
                color: ApplicationColors.ALERT_BOX_TEXT_COLOR,),
          ),
        ),
      ]),
    );
  }
}
