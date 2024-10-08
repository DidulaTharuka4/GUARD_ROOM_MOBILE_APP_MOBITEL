import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final String titleText;
  final TextEditingController inputController;
  final bool inputEnabled;
  // final String? inputTextError;
  final TextInputType keyboardType;
  // final int maxCharacterLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChange;
  final bool buttonClickStatus;
  final bool isRequired;
  final bool obscureText;
  final VoidCallback? onTap;
  // final bool controllerStatus;

  const CustomTextInput({
    Key? key,
    required this.titleText,
    required this.inputController,
    this.inputEnabled = true,
    // this.inputTextError = '',
    this.keyboardType = TextInputType.text,
    // required this.maxCharacterLength,
    this.inputFormatters,
    this.onChange,
    this.buttonClickStatus = false,
    required this.isRequired,
    this.obscureText = false,
    this.onTap,
    // this.controllerStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      margin: ApplicationMarginValues.pageInputFieldsMargin,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                titleText,
                style: TextStyle(
                    fontSize: ApplicationTextSizes.userInputFieldLabelValue(context),
                    // fontFamily: 'Poppins',
                    fontWeight: ApplicationTextWeights.UserInputsLabelWeight),
              ),
              Text(
                isRequired ? "*" : '',
                style: TextStyle(
                    fontSize: ApplicationTextSizes.userInputFieldLabelValue(context),
                    // color: ApplicationColors.RED_COLOR,
                    color: ApplicationColors.RED_COLOR,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: ApplicationMarginValues.textInputFieldInnerMargin,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: inputController,
                    enabled: inputEnabled,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    style: const TextStyle(
                      color: ApplicationColors.PURE_BLACK,
                    ),
                    // inputFormatters: <TextInputFormatter>[
                    //   VehicleNumberTextInputFormatter(),
                    //   LengthLimitingTextInputFormatter(maxCharacterLength)
                    // ],
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ApplicationColors.PURE_WHITE,
                      border: const OutlineInputBorder(),
                      // errorText: inputTextError
                      // errorText: inputController.text.isEmpty && isRequired? 'mandatory fields (*) cannot be empty' : ''
                      // errorText: inputController.text.isEmpty && buttonClickStatus? 'mandatory fields (*) cannot be empty' : ''
                      errorText: buttonClickStatus
                          ? inputController.text.isEmpty
                              ? 'mandatory fields (*) cannot be empty'
                              : ''
                          : '',
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: buttonClickStatus
                                ? inputController.text.isEmpty
                                    ? ApplicationColors.RED_COLOR
                                    : ApplicationColors.PURE_BLACK
                                : ApplicationColors
                                    .PURE_BLACK // Set to any color you want
                            ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ApplicationColors.PURE_BLACK,
                        ),
                      ),
                    ),
                    onChanged: onChange,
                    onTap: onTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filteredText =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}
