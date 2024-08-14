import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String titleText;
  final TextStyle textStyles;
  final TextEditingController inputController;
  final TextInputType keyboardType;
  final int maxCharacterLength;

  const CustomTextInput({
    Key? key,
    required this.titleText,
    required this.textStyles,
    required this.inputController,
    required this.keyboardType,
    required this.maxCharacterLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              titleText,
              style: textStyles,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: inputController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              maxLength: maxCharacterLength,
              decoration: InputDecoration(
                filled: true,
                fillColor: ApplicationColors.PURE_WHITE,
                border: OutlineInputBorder(),
                // hintText: 'Enter text here',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
