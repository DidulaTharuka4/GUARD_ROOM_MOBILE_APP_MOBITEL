import 'package:flutter/material.dart';

class MileageUnit extends ChangeNotifier {
  bool toggleValue1 = true;
  double mileageValueInDouble = 0.0;
  double convertedMileageValue = 0.0;

  void toggleUnit() {
    toggleValue1 = !toggleValue1;
    notifyListeners();
  }

  void mileageToggleButton(String mileageValue) {
    double mileageValueInDouble =
        double.tryParse(mileageValue ?? '') ?? 0.0;
    if (toggleValue1 == false) {
      convertedMileageValue = mileageValueInDouble * 1.60934;
      // convertedMileageValue = mileageValueInDouble * 0.6213711922;
    } else if (toggleValue1 == true) {
      convertedMileageValue = mileageValueInDouble;
    }
    notifyListeners();
  }

  // String get unit => toggleValue1 ? 'km' : 'miles';
  double get convertedMileage => convertedMileageValue;
}
