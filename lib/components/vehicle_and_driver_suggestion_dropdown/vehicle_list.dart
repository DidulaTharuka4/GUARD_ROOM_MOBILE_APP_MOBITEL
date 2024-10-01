import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class VehicleListProvider with ChangeNotifier {
  List<String> allVehicles = [];
  List<String> filteredVehicles = [];
  String? selectedVehicle;
  bool showDropdown = false;
  var logger = Logger();

  void vehicleNumberList(BuildContext context) {
    final findAllVehicles =
        Provider.of<FindAllVehiclesProvider>(context, listen: false);
    allVehicles.clear();

    for (int i = 0;
        i <
            findAllVehicles
                .findAllVehiclesResponse!.appVehicleMobileDtoList!.length;
        i++) {
      final vehicleDetailItem =
          findAllVehicles.findAllVehiclesResponse!.appVehicleMobileDtoList![i];
      // allVehicles.add(vehicleDetailItem.vehicleRegNumber.toString());
      allVehicles.add(vehicleDetailItem.vehicleRegNumber.toString());
    }
    
    logger.i(allVehicles);
    logger.i('end');
    notifyListeners();
  }

  void filterVehicles(BuildContext context, String query) {
    vehicleNumberList(context);

    logger.i(query);

    filteredVehicles = allVehicles
        .where((vehicle) => vehicle.toLowerCase().contains(query.toLowerCase()))
        .toList();

    logger.i(filteredVehicles);

    if (filteredVehicles.isEmpty) {
      selectedVehicle = null;
    } else if (filteredVehicles.contains(selectedVehicle)) {
      selectedVehicle = selectedVehicle;
    } else {
      selectedVehicle = null;
    }
    logger.i('start');
    showDropdown = filteredVehicles.isNotEmpty && query.isNotEmpty;
    notifyListeners();
  }
}
