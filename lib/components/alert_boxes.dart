import 'package:Guard_Room_Application/components/alert_boxes/invalid_input_alert_box.dart';
import 'package:Guard_Room_Application/components/alert_boxes/confirmation_alert_box.dart';
import 'package:flutter/material.dart';

enum AlertType {
  successStatus,
  confirmation,
  invalidInput,
}

// class MyWidget extends StatelessWidget {
//   final AlertType currentState;

//   MyWidget({required this.currentState});

//   @override
//   Widget build(BuildContext context) {
//     Widget content;

//     switch (currentState) {
//       case AlertType.successStatus:
//         // WidgetsBinding.instance.addPostFrameCallback((_) {
//         //   invalidFieldAlertDialogBox(context);
//         // });
//         // content = const CircularProgressIndicator();

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               contentPadding: const EdgeInsets.all(0.0),
//               content: AlertDialogBoxSelector(
//                   pressForYesButton: () {
//                     Navigator.of(context).pop();
//                   },
//                   alertDialogText:
//                       'Are you sure you want record attendance for Vehicle Number :  ?'),
//             );
//           },
//         );
//         break;

//       case AlertType.confirmation:
//         // WidgetsBinding.instance.addPostFrameCallback((_) {
//         //   invalidFieldAlertDialogBox(context);
//         // });
//         // content = const Text('Data Loaded Successfully');

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               contentPadding: const EdgeInsets.all(0.0),
//               content: AlertDialogBoxSelector(
//                   pressForYesButton: () {
//                     Navigator.of(context).pop();
//                   },
//                   alertDialogText:
//                       'Are you sure you want record attendance for Vehicle Number :  ?'),
//             );
//           },
//         );

//         break;

//       case AlertType.invalidInput:
//         // WidgetsBinding.instance.addPostFrameCallback((_) {
//         //   invalidFieldAlertDialogBox(context);
//         // });
//         // content = const Text('An error occurred');

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               contentPadding: const EdgeInsets.all(0.0),
//               content: AlertDialogBoxSelector(
//                   pressForYesButton: () {
//                     Navigator.of(context).pop();
//                   },
//                   alertDialogText:
//                       'Are you sure you want record attendance for Vehicle Number :  ?'),
//             );
//           },
//         );
//         break;

//       default:
//         content = const Text('Unknown State');
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Switch Case Example'),
//       ),
//       body: Center(
//         child: content,
//       ),
//     );
//   }
// }

// void showAlert(BuildContext context, AlertType alertType) {
//   final String alertDialogText;
//   final VoidCallback pressForYesButton;
//   switch (alertType) {
//     case AlertType.successStatus:
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0.0),
//             content: AlertDialogBoxSelector(
//                 pressForYesButton: () {
//                   Navigator.of(context).pop();
//                 },
//                 alertDialogText:
//                     'Are you sure you want record attendance for Vehicle Number :  ?'),
//           );
//         },
//       );
//       break;

//     case AlertType.confirmation:
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0.0),
//             content: AlertDialogBoxSelector(
//                 // pressForYesButton: () {
//                 //   Navigator.of(context).pop();
//                 // },
//                 pressForYesButton: pressForYesButton,
//                 alertDialogText:
//                     'Are you sure you want record attendance for Vehicle Number :  ?'),
//           );
//         },
//       );

//       break;

//     case AlertType.invalidInput:
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0.0),
//             content: AlertDialogBoxSelector(
//                 pressForYesButton: () {
//                   Navigator.of(context).pop();
//                 },
//                 alertDialogText:
//                     'Are you sure you want record attendance for Vehicle Number :  ?'),
//           );
//         },
//       );
//       break;
//   }
// }

class AlertDialogBoxes extends StatelessWidget {
  final String vehicleNumber;
  final VoidCallback pressForYesButton;

  const AlertDialogBoxes({
    super.key,
    required this.vehicleNumber,
    required this.pressForYesButton,
  });

  void invalidFieldAlertDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: AlertDialogBox(),
        );
      },
    );
  }

  void workInOutButtonDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          content: AlertDialogBoxSelector(
              pressForYesButton: pressForYesButton,
              alertDialogText:
                  'Are you sure you want record attendance for Vehicle Number $vehicleNumber:  ?'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// void invalidFieldAlertDialogBox(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return const AlertDialog(
//         contentPadding: EdgeInsets.all(0.0),
//         content: AlertDialogBox(),
//       );
//     },
//   );
// }

// void workInButtonDialogBox(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: EdgeInsets.all(0.0),
//         content: AlertDialogBoxSelector(
//             pressForYesButton: () {
//               // startWithWithoutSelector();
//               Navigator.of(context).pop();
//             },
//             alertDialogText:
//                 // 'Are you sure you want record attendance for Vehicle Number ${_vehicleNumberController.text} ${_replaceVehicleNumberController.text}:  ?'
//                 'Are you sure you want record attendance for Vehicle Number :  ?'),
//       );
//     },
//   );
// }
