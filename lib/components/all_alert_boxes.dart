import 'package:Guard_Room_Application/components/alert_boxes/confirmation_alert_box.dart';
import 'package:Guard_Room_Application/components/alert_boxes/success_error_alert_box.dart';
import 'package:flutter/material.dart';

void workInOutButtonDialogBox(
    BuildContext context, String vehicleNumber, Function pressForYesButton) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        content: AlertDialogBoxSelector(
            pressForYesButton: pressForYesButton(),
            alertDialogText:
                'Are you sure you want record attendance for Vehicle Number $vehicleNumber:  ?'),
      );
    },
  );
}

void finalResponseStatusDialogBox(BuildContext context, bool successStatus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        content: SuccessStatusAlertBox(
          successStatus: successStatus!,
        ),
      );
    },
  );
}
