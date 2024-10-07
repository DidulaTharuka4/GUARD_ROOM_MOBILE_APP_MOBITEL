import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sample_flutter_application_1/constraints/colors.dart';
// import 'package:sample_flutter_application_1/constraints/textSizes.dart';

class AlertDialogBox extends StatelessWidget {

  const AlertDialogBox({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 1.0549,
      height: screenSize.height / 4.9460,
      // width: 390,
      // height: 180,
      decoration: BoxDecoration(
        color: ApplicationColors.CUSTOM_ERROR_ALERT_BOX,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: ApplicationColors.RED_COLOR,
          width: 1,
        ),
      ),
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: SvgPicture.asset('assets/images/warning.svg',
              width: screenSize.width / 9.3506,
              height: screenSize.width / 9.3506
              // width: 44,
              // height: 44
              ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ApplicationTextSizes.FInalResponseAlertTextTitle(context),
              fontWeight: ApplicationTextWeights.PageTitleTextWeight,
              fontFamily: 'Poppins',
              color: ApplicationColors.RED_COLOR,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: Text(
            // 'Unable to continue due to invalid inputs.',
            'Unable to continue !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ApplicationTextSizes.FInalResponseAlertText(context),
              fontWeight: ApplicationTextWeights.UserInputsLabelWeight,
              fontFamily: 'Poppins',
              color: ApplicationColors.ALERT_BOX_TEXT_COLOR,
            ),
          ),
        ),
      ]),
    );
  }
}
