import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectorButton extends StatelessWidget {
  final String innerText;
  final VoidCallback onPress;

  const SelectorButton({
    super.key,
    required this.innerText,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        // minimumSize: Size(277.6542, 108.048),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
        onPressed: onPress,
        child: Stack(children: <Widget>[
          Container(
            // width: 377.6542,
            // height: 108.048,
            width: screenSize.width / 1.09,
            height: screenSize.height / 8.24,
            decoration: BoxDecoration(
              color: ApplicationColors.BG_LIGHT_BLUE,
              border: Border.all(
                color: ApplicationColors.BORDER_BLUE,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Positioned(
            // top: 10.0,
            // left: 10.0,
            top: (screenSize.height / 8.24) / 10.81,
            left: (screenSize.height / 8.24) / 10.81,
            child: SvgPicture.asset('assets/images/selector_dots.svg',
                // width: 81.036, height: 81.036,
                width: (screenSize.height / 8.24) / 1.33,
                height: (screenSize.height / 8.24) / 1.33),
          ),
          Positioned(
            // bottom: 10.0,
            // left: 30.0,
            bottom: (screenSize.height / 8.24) / 10.81,
            left: (screenSize.height / 8.24) / 3.60,
            child: Text(
              innerText,
              style: TextStyle(
                  fontSize: ApplicationTextSizes.SelectorButtonTitleValue(context),
                  fontFamily: 'Poppins',
                  fontWeight: ApplicationTextWeights.PageTitleTextWeight,
                  color: ApplicationColors.MAIN_COLOR_BLUE),
            ),
          ),
          Positioned(
            // bottom: 40.8362,
            // right: 20.5,
            bottom: ((screenSize.height / 8.24) - (screenSize.height / 62.14)) / 2,
            right: screenSize.width / 20.07,
            child: SvgPicture.asset('assets/images/Next_Arrow.svg',
                // width: 8.2071, height: 14.3276,
                width: screenSize.width / 50.13,
                height: screenSize.height / 62.14),
          ),
        ]));
  }
}
