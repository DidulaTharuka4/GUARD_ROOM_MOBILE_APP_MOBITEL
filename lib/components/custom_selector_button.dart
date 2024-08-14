import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
// import 'package:sample_flutter_application_1/constraints/colors.dart';
// import 'package:sample_flutter_application_1/constraints/textSizes.dart';

class CustomSelectorButton extends StatefulWidget {
  final VoidCallback changeToggleAction;

  CustomSelectorButton({
    Key? key,
    required this.changeToggleAction,
  }) : super(key: key);
  @override
  _CustomSelectorButtonState createState() => _CustomSelectorButtonState();
}

class _CustomSelectorButtonState extends State<CustomSelectorButton> {
  bool isSelected = true;
  // isNotSelected =! isSelected
  // bool isNotSelected = false;

  late VoidCallback _changeToggleAction;

  void initState() {
    super.initState();
    _changeToggleAction = widget.changeToggleAction;
  }

  // void _toggleSelected() {
  //   print(isSelected);
  //   setState(() {
  //     isSelected = !isSelected;
  //   });
  //   print(isSelected);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
            // _toggleSelected();
            _changeToggleAction();
          },
          child: Container(
            child: Stack(children: <Widget>[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? ApplicationColors.BUTTON_COLOR_BLUE
                        : ApplicationColors.BUTTON_COLOR_BLUE,
                    width: 2,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ApplicationColors.BUTTON_COLOR_BLUE
                        : ApplicationColors.PURE_WHITE,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
          )),
      SizedBox(width: 5),
      Text(
        'km',
        // mileageUnit,
        // Provider.of<MileageUnit>(context).unit,
        style: TextStyle(
            fontSize: ApplicationTextSizes.userInputFieldLabelValue,
            fontFamily: 'Poppins',
            fontWeight: ApplicationTextWeights.UserInputsLabelWeight),
      ),

      // next-------------------------------------------------------------------

      SizedBox(width: 10),
      GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
            // _toggleSelected();
            _changeToggleAction();
          },
          child: Container(
            child: Stack(children: <Widget>[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? ApplicationColors.BUTTON_COLOR_BLUE
                        : ApplicationColors.BUTTON_COLOR_BLUE,
                    width: 2,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ApplicationColors.PURE_WHITE
                        : ApplicationColors.BUTTON_COLOR_BLUE,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
          )),
      SizedBox(width: 5),
      Text(
        'Miles',
        // mileageUnit,
        // Provider.of<MileageUnit>(context).unit,
        style: TextStyle(
            fontSize: ApplicationTextSizes.userInputFieldLabelValue,
            fontFamily: 'Poppins',
            fontWeight: ApplicationTextWeights.UserInputsLabelWeight),
      )
    ]));
  }
}
