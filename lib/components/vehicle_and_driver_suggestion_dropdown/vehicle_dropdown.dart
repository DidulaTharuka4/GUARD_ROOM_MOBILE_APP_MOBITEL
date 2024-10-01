import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/vehicle_list.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleDropdown extends StatelessWidget {
  final TextEditingController vehicleNumberController;
  final TextEditingController driverLicenseController;
  final TextEditingController driverNameController;
  final Function(String?) onVehicleSelected;

  const VehicleDropdown({
    Key? key,
    required this.vehicleNumberController,
    required this.driverLicenseController,
    required this.driverNameController,
    required this.onVehicleSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final vehicleListProvider = Provider.of<VehicleListProvider>(context);
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);

    return vehicleListProvider.showDropdown
        ? Positioned(
            child: Container(
              color: ApplicationColors.PURE_WHITE,
              constraints: const BoxConstraints(maxHeight: 200),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300,
                  minHeight: 150,
                  maxWidth: 350,
                  minWidth: 100,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehicleListProvider.filteredVehicles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(vehicleListProvider.filteredVehicles[index]),
                      onTap: () {
                        vehicleListProvider.showDropdown = false;

                        onVehicleSelected(
                            vehicleListProvider.filteredVehicles[index]
                            );

                        if (driverLicenseController.text.isEmpty) {
                          vehicleNumberController.text =
                              vehicleListProvider.filteredVehicles[index];

                          for (int i = 0;
                              i <
                                  findAllVehiclesProvider
                                      .findAllVehiclesResponse!
                                      .appVehicleMobileDtoList!
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList![i];

                            if (vehicle?.vehicleRegNumber ==
                                vehicleNumberController.text) {
                              // Handle vehicle and driver details
                              driverLicenseController.text =
                                  '${vehicle!.driverDto!.licenseNum}';
                              driverNameController.text =
                                  '${vehicle.driverDto!.cname}';
                            }
                          }
                        } else {
                          for (int i = 0;
                              i <
                                  findAllVehiclesProvider
                                      .findAllVehiclesResponse!
                                      .appVehicleMobileDtoList!
                                      .length;
                              i++) {
                            final vehicle = findAllVehiclesProvider
                                .findAllVehiclesResponse
                                ?.appVehicleMobileDtoList![i];

                            if (vehicle?.driverDto!.licenseNum ==
                                driverLicenseController.text) {
                              vehicleNumberController.text =
                                  '${vehicle?.vehicleRegNumber}';
                              break;
                            } else {
                              vehicleNumberController.text =
                                  vehicleListProvider.filteredVehicles[index];
                            }
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          )
        : Container();
  }
}
