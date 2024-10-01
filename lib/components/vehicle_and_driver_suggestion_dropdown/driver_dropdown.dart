import 'package:Guard_Room_Application/components/vehicle_and_driver_suggestion_dropdown/driver_list.dart';
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:Guard_Room_Application/providers/find_all_vehicles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LicenseNumberDropdown extends StatelessWidget {
  final TextEditingController vehicleNumberController;
  final TextEditingController driverLicenseController;
  final TextEditingController driverNameController;
  final Function(String?) onDriverSelected;

  const LicenseNumberDropdown({
    Key? key,
    required this.vehicleNumberController,
    required this.driverLicenseController,
    required this.driverNameController,
    required this.onDriverSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final licenseListProvider = Provider.of<LicenseNumberListProvider>(context);
    final findAllVehiclesProvider =
        Provider.of<FindAllVehiclesProvider>(context);

    final findAllDriversProvider = Provider.of<FindAllDriversProvider>(context);

    return licenseListProvider.showLicenseNumberDropdown
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
                  itemCount: licenseListProvider.filteredLicenseNumbers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          licenseListProvider.filteredLicenseNumbers[index]),
                      onTap: () {
                        // licenseListProvider.showLicenseNumberDropdown = false;

                        onDriverSelected(
                            licenseListProvider.filteredLicenseNumbers[index]);

                        if (vehicleNumberController.text.isEmpty) {
                          driverLicenseController.text =
                              licenseListProvider.filteredLicenseNumbers[index];

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

                            for (int m = 0;
                                m <
                                    findAllDriversProvider
                                        .findAllDriversResponse!
                                        .appDriverMobileDtoList
                                        .length;
                                m++) {
                              final driver = findAllDriversProvider
                                  .findAllDriversResponse
                                  ?.appDriverMobileDtoList[m];

                              if (vehicle?.driverDto!.licenseNum ==
                                  driverLicenseController.text) {
                                // Handle vehicle and driver details
                                vehicleNumberController.text =
                                    '${vehicle!.vehicleRegNumber}';
                                driverNameController.text =
                                    '${vehicle.driverDto!.cname}';
                              } else if (driver?.licenseNum == driverLicenseController.text) {
                                driverNameController.text =
                                    '${driver!.cname}';
                              }
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
                              vehicleNumberController.text = licenseListProvider
                                  .filteredLicenseNumbers[index];
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
