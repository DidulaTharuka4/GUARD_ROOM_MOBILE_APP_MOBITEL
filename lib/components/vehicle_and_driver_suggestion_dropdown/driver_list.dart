import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class LicenseNumberListProvider with ChangeNotifier {
  List<String> allLicenseNumbers = [];
  List<String> filteredLicenseNumbers = [];
  String? selectedLicenseNumber;
  bool showLicenseNumberDropdown = false;
  var logger = Logger();

  void licenseNumberList(BuildContext context) {
    logger.i('B4 for loop');
    final findAllLicenseNumbers =
        Provider.of<FindAllDriversProvider>(context, listen: false);

    final findLicenseNumbersAttachedWithVehicles =
        Provider.of<FindAllVehiclesProvider>(context, listen: false);

    allLicenseNumbers.clear();

    for (int i = 0;
        i <
            findLicenseNumbersAttachedWithVehicles
                .findAllVehiclesResponse!.appVehicleMobileDtoList!.length;
        i++) {
      final licenseNumberItem = findLicenseNumbersAttachedWithVehicles
          .findAllVehiclesResponse!.appVehicleMobileDtoList![i];

      // Using a simple conditional check with null-aware operator
      if (licenseNumberItem.driverDto?.licenseNum != null) {
        allLicenseNumbers
            .add(licenseNumberItem.driverDto!.licenseNum.toString());
      }
    }

    // for (int m = 0;
    //     m <
    //         findAllLicenseNumbers
    //             .findAllDriversResponse!.appDriverMobileDtoList.length;
    //     m++) {
    //   final allLicenseNumberItem = findAllLicenseNumbers
    //       .findAllDriversResponse!.appDriverMobileDtoList[m];

    //   if (allLicenseNumberItem.licenseNum != null &&
    //       allLicenseNumbers[m] != allLicenseNumberItem.licenseNum) {
    //     allLicenseNumbers.add(allLicenseNumberItem.licenseNum.toString());
    //   }
    // }

    for (int m = 0;
        m <
            findAllLicenseNumbers
                .findAllDriversResponse!.appDriverMobileDtoList.length;
        m++) {
      final allLicenseNumberItem = findAllLicenseNumbers
          .findAllDriversResponse!.appDriverMobileDtoList[m];

      if (allLicenseNumberItem.licenseNum != null &&
          !allLicenseNumbers.contains(allLicenseNumberItem.licenseNum)) {
        allLicenseNumbers.add(allLicenseNumberItem.licenseNum.toString());
      }
    }

    logger.i(allLicenseNumbers);
    logger.i('end');
  }

  void filterLicenseNumbers(BuildContext context, String query) {
    logger.i('inside the func 1');
    licenseNumberList(context);

    logger.i(query);

    filteredLicenseNumbers = allLicenseNumbers
        .where((licenseNumber) =>
            licenseNumber.toLowerCase().contains(query.toLowerCase()))
        .toList();

    logger.i(filteredLicenseNumbers);

    if (filteredLicenseNumbers.isEmpty) {
      selectedLicenseNumber = null;
    } else if (filteredLicenseNumbers.contains(selectedLicenseNumber)) {
      // Keep the selected vehicle if it's still in the filtered list
      selectedLicenseNumber = selectedLicenseNumber;
    } else {
      // Reset selection if the previously selected vehicle is not in the filtered list
      selectedLicenseNumber = null;
    }

    logger.i('start');
    showLicenseNumberDropdown =
        filteredLicenseNumbers.isNotEmpty && query.isNotEmpty;
  }
}
