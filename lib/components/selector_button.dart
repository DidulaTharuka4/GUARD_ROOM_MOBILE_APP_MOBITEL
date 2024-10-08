import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectorButton extends StatelessWidget {
  final String innerText;
  final VoidCallback onPress;

  const SelectorButton({
    Key? key,
    required this.innerText,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            width: screenSize.width / 1.0894,
            height: screenSize.height / 8.2397,
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
            top: (screenSize.height / 8.2397) / 10.8048,
            left: (screenSize.height / 8.2397) / 10.8048,
            child: SvgPicture.asset('assets/images/selector_dots.svg',
                // width: 81.036, height: 81.036,
                width: (screenSize.height / 8.2397) / 1.3333,
                height: (screenSize.height / 8.2397) / 1.3333),
          ),
          Positioned(
            // bottom: 10.0,
            // left: 30.0,
            bottom: (screenSize.height / 8.2397) / 10.8048,
            left: (screenSize.height / 8.2397) / 3.6016,
            child: Text(
              innerText,
              style: TextStyle(
                  fontSize: ApplicationTextSizes.SelectorButtonTitleValue,
                  fontFamily: 'Poppins',
                  fontWeight: ApplicationTextWeights.PageTitleTextWeight,
                  color: ApplicationColors.MAIN_COLOR_BLUE),
            ),
          ),
          Positioned(
            // bottom: 40.8362,
            // right: 20.5,
            bottom: ((screenSize.height / 8.2397) - (screenSize.height / 62.1378)) / 2,
            right: screenSize.width / 20.0696,
            child: SvgPicture.asset('assets/images/Next_Arrow.svg',
                // width: 8.2071, height: 14.3276,
                width: screenSize.width / 50.1308,
                height: screenSize.height / 62.1378),
          ),
        ]));
  }
}
