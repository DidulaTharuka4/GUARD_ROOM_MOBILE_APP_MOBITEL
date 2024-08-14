import 'package:Guard_Room_Application/providers/find_all_drivers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sample_flutter_application_1/providers/find_all_drivers_provider.dart';
// import 'driver_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver List'),
      ),
      body: Consumer<FindAllDriversProvider>(
        builder: (context, driverProvider, child) {
          if (driverProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (driverProvider.isLoading) {
            return Center(
              child: Text('No Drivers Available'),
            );
          } else {
            return ListView.builder(
              // itemCount: driverProvider.getAllDrivers?.appDriverMobileDtoList.length,
              itemBuilder: (context, index) {
                // final driver = driverProvider.getAllDrivers?.appDriverMobileDtoList[index];
                return ListTile(
                  title: Text('${driverProvider.getAllDrivers?.appDriverMobileDtoList[1].cname}'),
                  subtitle: Text('NIC: ${driverProvider.getAllDrivers?.appDriverMobileDtoList[1].licenseNum}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<FindAllDriversProvider>(context, listen: false).getAllDrivers;
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
