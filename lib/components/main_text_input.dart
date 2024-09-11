// import 'package:Guard_Room_Application/constraints/colors.dart';
// import 'package:Guard_Room_Application/constraints/textSizes.dart';
// import 'package:flutter/material.dart';

// class CustomTextInput extends StatelessWidget {
//   final String titleText;
//   final TextStyle textStyles;
//   final TextEditingController inputController;
//   final TextInputType keyboardType;
//   final int maxCharacterLength;

//   const CustomTextInput({
//     Key? key,
//     required this.titleText,
//     required this.textStyles,
//     required this.inputController,
//     required this.keyboardType,
//     required this.maxCharacterLength,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: Text(
//               titleText,
//               style: const TextStyle(
//                   fontSize: ApplicationTextSizes.userInputFieldLabelValue,
//                   fontFamily: 'Poppins',
//                   fontWeight: ApplicationTextWeights.UserInputsLabelWeight),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             flex: 1,
//             child: TextFormField(
//               controller: inputController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'This field is required';
//                 }
//                 return null;
//               },
//               maxLength: maxCharacterLength,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: ApplicationColors.PURE_WHITE,
//                 border: OutlineInputBorder(),
//                 // hintText: 'Enter text here',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/constraints/marginValues.dart';
import 'package:Guard_Room_Application/constraints/textSizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final String titleText;
  final TextEditingController inputController;
  final bool inputEnabled;
  final String? inputTextError;
  final TextInputType keyboardType;
  // final int maxCharacterLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChange;

  const CustomTextInput({
    Key? key,
    required this.titleText,
    required this.inputController,
    this.inputEnabled = true,
    this.inputTextError = '',
    this.keyboardType = TextInputType.text,
    // required this.maxCharacterLength,
    this.inputFormatters,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ApplicationMarginValues.pageInputFieldsMargin,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                titleText,
                style: const TextStyle(
                    fontSize: ApplicationTextSizes.userInputFieldLabelValue,
                    // fontFamily: 'Poppins',
                    fontWeight: ApplicationTextWeights.UserInputsLabelWeight),
              ),
              const Text(
                "*",
                style: TextStyle(
                    fontSize: ApplicationTextSizes.userInputFieldLabelValue,
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
                      errorText: inputTextError
                    ),
                    onChanged: onChange,
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
