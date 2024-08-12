import 'package:flutter/material.dart';
import 'package:sample_flutter_application_1/constraints/colors.dart';

class CustomToggleButton extends StatefulWidget {
  // final Color backgroundColor;
  // final Color dotColor;
  final VoidCallback changeToggleAction;

  CustomToggleButton( 
      {Key? key,
      // required this.backgroundColor,
      // required this.dotColor,
      required this.changeToggleAction,
      })
      : super(key: key);
  @override
  _CustomToggleButton createState() => _CustomToggleButton();
}

class _CustomToggleButton extends State<CustomToggleButton> {

  bool isToggled = false;

  late Color backgroundColor;
  late Color dotColor;
  late VoidCallback changeToggleAction;

  void initState() {
    super.initState();
    // backgroundColor = widget.backgroundColor;
    // dotColor = widget.dotColor;
    changeToggleAction = widget.changeToggleAction;
  }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
        });
        changeToggleAction();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // color: ApplicationColors.BUTTON_COLOR_BLUE,
          // color: ApplicationColors.TOGGLE_BUTTON_OFF_COLOR,
          color: isToggled ? ApplicationColors.BUTTON_COLOR_BLUE : ApplicationColors.TOGGLE_BUTTON_OFF_COLOR,
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              left: isToggled ? 30.0 : 0.0,
              right: isToggled ? 0.0 : 30.0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isToggled = !isToggled;
                  });
                  changeToggleAction();
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: Icon(
                          Icons.circle,
                          color: ApplicationColors.PURE_WHITE,
                          size: 26.0,
                          key: UniqueKey(),
                        )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
