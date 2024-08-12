import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'package:sample_flutter_application_1/components/TileCard.dart';
// import 'package:sample_flutter_application_1/components/cusSel.dart';
import 'package:sample_flutter_application_1/components/custom_alert_dialog.dart';
// import 'package:sample_flutter_application_1/components/custom_button.dart';
// import 'package:sample_flutter_application_1/components/custom_selector_button.dart';
// import 'package:sample_flutter_application_1/components/custom_toggle_button.dart';
import 'package:sample_flutter_application_1/constraints/colors.dart';
// import 'package:sample_flutter_application_1/notifiers/mileage_unit.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  DateTime? _selectedDate;

  // Method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _driverLicenseController =
      TextEditingController();

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(
              alertDialogText:
                  'Cannot proceed with invalid inputs! Please try again.'),
          // minimumSize: Size(buttonWidth, buttonHeight),
        );
      },
    );
  }

  final List<String> _provinceDropdownItems = [
    'CP',
    'EP',
    'NC',
    'NE',
    'NW',
    'SB',
    'SP',
    'UP',
    'WP',
    'N/A'
  ];
  String? _selectedVehicleProvince;

  bool toggleValue1 = false;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ApplicationColors.PURE_WHITE,
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Selected Date Display---------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              //   child: Text(
              //     _selectedDate == null
              //         ? 'No date selected!'
              //         : 'Selected Date: ${_selectedDate!.toLocal()}'
              //             .split(' ')[0],
              //   ),
              // ),

              // Select Date Button------------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              //   child: ElevatedButton(
              //     onPressed: () => _selectDate(context),
              //     child: Text('Select date : '),
              //     // child: Text(screenSize.width),
              //   ),
              // ),

              // Selected Time Display---------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              //   child: Text(
              //     'Selected Time: ${_selectedTime.format(context)}',
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),

              // Select Time Button------------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              //   child: ElevatedButton(
              //     onPressed: () => _selectTime(context),
              //     child: Text('Select Time'),
              //   ),
              // ),

              // Reusable Button Component-Go Back--------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              //   child: CustomButton(
              //     onPress: () {
              //       Navigator.pop(context);
              //     },
              //     innerText: 'Go back',
              //     backgroundColor: Colors.grey,
              //     borderRadius: 10,
              //     buttonWidth: 200,
              //     buttonHeight: 40,
              //     textStyles: TextStyle(
              //         fontSize: 17,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black),
              //   ),
              // ),

              // SizedBox(height: 20),

              // Normal Text Input Field--------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         flex: 1,
              //         child: Text(
              //           'Vehiclke Number : *',
              //           style: TextStyle(
              //               fontSize: 15.0, fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       Expanded(
              //         flex: 1,
              //         child: Row(
              //           children: <Widget>[
              //             Expanded(
              //               flex: 4,
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     'Province',
              //                     style: TextStyle(
              //                         fontSize: 12.0,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                   DropdownButton<String>(
              //                     // hint: Text('Select an option'),
              //                     // dropdownColor: Colors.white,
              //                     dropdownColor: ApplicationColors.PURE_WHITE,
              //                     // iconEnabledColor: Colors.black,
              //                     iconEnabledColor:
              //                         ApplicationColors.PURE_BLACK,
              //                     value: _selectedVehicleProvince,
              //                     onChanged: (String? newValue) {
              //                       setState(() {
              //                         _selectedVehicleProvince = newValue;
              //                       });
              //                     },
              //                     items: _provinceDropdownItems
              //                         .map<DropdownMenuItem<String>>(
              //                             (String value) {
              //                       return DropdownMenuItem<String>(
              //                         value: value,
              //                         child: Text(value),
              //                       );
              //                     }).toList(),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             SizedBox(width: 10),
              //             Expanded(
              //               flex: 6,
              //               child: TextFormField(
              //                 // validator: (value) {
              //                 //   if (value == null || value.isEmpty) {
              //                 //     return 'Please enter some text';
              //                 //   }
              //                 //   return null;
              //                 // },
              //                 maxLength: 8,
              //                 inputFormatters: [UpperCaseTextInputFormatter()],
              //                 // String filtered = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
              //                 controller: _vehicleNumberController,
              //                 decoration: InputDecoration(
              //                   filled: true,
              //                   // fillColor: Colors.white,
              //                   fillColor: ApplicationColors.PURE_WHITE,
              //                   border: OutlineInputBorder(),
              //                   // hintText: 'Enter text here',
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Inkwell sample-Tap me Button--------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              //   child: InkWell(
              //     onTap: () {
              //       print('InkWell tapped');
              //       print(toggleValue1);
              //       // Perform any action you want here
              //     },
              //     child: Container(
              //       padding: EdgeInsets.all(20.0),
              //       decoration: BoxDecoration(
              //         color: ApplicationColors.RED_COLOR,
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //       child: Text(
              //         'Tap me',
              //         style: TextStyle(
              //           color: ApplicationColors.PURE_BLACK,
              //           fontSize: 20.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Pop-Up Message Button---------------------------------------------
              // Container(
              //   margin: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              //   child: CustomButton(
              //     onPress: () {
              //       // Navigator.pop(context);
              //       showCustomDialog(context);
              //       // print(toggleValue1);
              //       // AlertDialog(
              //       //   contentPadding: EdgeInsets.all(16.0),
              //       //   content: AlertDialogBox(alertDialogText: "Hi!"),
              //       // );
              //     },
              //     innerText: 'Pop-up message',
              //     backgroundColor: ApplicationColors.RED_COLOR,
              //     borderRadius: 10,
              //     buttonWidth: 200,
              //     buttonHeight: 40,
              //     textStyles: TextStyle(
              //         fontSize: 17,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black),
              //   ),
              // ),

              // Custom Toggle Button
              // Container(
              //   margin: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              //   child: CustomToggleButton(
              //     backgroundColor: ApplicationColors.BACKGROUND_BLUE,
              //     dotColor: ApplicationColors.RED_COLOR,
              //     changeToggleAction: () {
              //       // Navigator.pop(context);
              //       toggleValue1 = !toggleValue1;
              //     },
              //   ),
              // ),

              // Custom Toggle Button 2
              // Container(
              //   margin: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
              //   child: CustomToggleButton(
              //     changeToggleAction: () {
              //       setState(() {
              //         toggleValue1 = !toggleValue1;
              //       });
              //     },
              //     backgroundColor: ApplicationColors.pureWhite,
              //     dotColor: ApplicationColors.pureBlack,
              //   ),
              // )

              // Container(
              //   child: CustomSelectorButton()
              // ),

              // Container(child: CustomSelectorButtona(
              //   changeToggleAction: () {
              //     Provider.of<MileageUnit>(context, listen: false).toggleUnit();
              //   },
              // )),

              // Container(
              //     child: Column(
              //   children: <Widget>[
              //     Switch(
              //       value: _expanded,
              //       onChanged: (bool value) {
              //         setState(() {
              //           _expanded = value;
              //         });
              //       },
              //     ),
              //     Visibility(
              //       visible: _expanded,
              //       child: ExpansionTile(
              //         title: Text('Expandable Tile'),
              //         children: <Widget>[
              //           ListTile(title: Text('Item 1')),
              //           ListTile(title: Text('Item 2')),
              //           ListTile(title: Text('Item 3')),
              //         ],
              //       ),
              //     ),
              //   ],
              // )),

              // Container(
              //     child: Column(
              //   children: <Widget>[
              //     IconButton(
              //       icon:
              //           Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              //       onPressed: () {
              //         setState(() {
              //           _expanded = !_expanded;
              //         });
              //       },
              //     ),
              //     AnimatedContainer(
              //       duration: Duration(milliseconds: 300),
              //       child: _expanded
              //           ? ExpansionTile(
              //               initiallyExpanded: true,
              //               title: Text('Expandable Tile'),
              //               children: <Widget>[
              //                 ListTile(title: Text('Item 1')),
              //                 ListTile(title: Text('Item 2')),
              //                 ListTile(title: Text('Item 3')),
              //               ],
              //             )
              //           : SizedBox.shrink(),
              //     ),
              //   ],
              // )),

              Container(
                child: MyTileCard(title: 'This is Tile Card',)
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(r'[A-Z0-9-]');
    String filteredText =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}
