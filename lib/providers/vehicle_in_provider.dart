import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/vehicle_in_with_temp_model.dart';
import 'package:Guard_Room_Application/models/vehicle_in_without_temp_model.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
import 'package:logger/logger.dart';

// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/vehicle_in_with_temp_model.dart';
// import 'package:sample_flutter_application_1/models/vehicle_in_without_temp_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

class VehicleInProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  VehicleInWithTempResponse? vehicleInWithTemp;
  VehicleInWithoutTempResponse? vehicleInWithoutTemp;

  String? get token => _token;
  bool get isLoading => _isLoading;
  VehicleInWithTempResponse? get vehicleInWithTempResponse => vehicleInWithTemp;
  VehicleInWithoutTempResponse? get vehicleInWithoutTempResponse =>
      vehicleInWithoutTemp;

  final ApiServices apiService = ApiServices();

  Future<void> VehicleInWIthTemp(getVehicleInWithTemp) async {
    const url = ApplicationServices.vehicleInOutUrl;
    final token = await getToken();
    final withTempRequestBody = getVehicleInWithTemp;
    final withTempHeaders = Headers(token);

    try {
      _isLoading = true;
      notifyListeners();

      // final withTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withTempHeaders,
      //   body: json.encode(withTempRequestBody),
      // );

      final withTempResponseBody =
          await apiService.postRequest(url, withTempHeaders, withTempRequestBody);

      vehicleInWithTemp =
            VehicleInWithTempResponse.fromJson(withTempResponseBody);

      // print('yai yai yai');
      logger.i('yai yai yai');
      // print(withTempRequestBody);
      // logger.i(withTempRequestBody);
      // print(withTempResponse.statusCode);
      // logger.i(withTempResponse.statusCode);
      // print(withTempResponse.body);
      // logger.i(withTempResponse.body);
      // print('gtr r35');
      logger.i(withTempResponseBody);
      logger.i('gtr r35');

      // if (withTempResponse.statusCode == 200) {
      //   final withTempResponseData = json.decode(withTempResponse.body);
      //   vehicleInWithTemp =
      //       VehicleInWithTempResponse.fromJson(withTempResponseData);
      //   print('VehicleInWithTempProvider successful: $withTempResponseData');
      // } else {
      //   print('now in VehicleInWithTempProvider provider response line 4');
      //   throw Exception('Failed to VehicleInWithTempProvider');
      // }
    } catch (error) {
      print('Error occurred in VehicleInWithTempProvider provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //---------------------------------------------------------------------------

  Future<void> VehicleInWithoutTemp(getVehicleInWithoutTemp) async {
    const url = ApplicationServices.vehicleInOutUrl;
    final token = await getToken();
    final withoutTempRequestBody = getVehicleInWithoutTemp;
    final withoutTempHeaders = Headers(token);

    try {
      _isLoading = true;
      notifyListeners();

      // final withoutTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withoutTempHeaders,
      //   body: json.encode(withoutTempRequestBody),
      // );

      final withoutTempResponseBody =
          await apiService.postRequest(url, withoutTempHeaders, withoutTempRequestBody);

      vehicleInWithoutTemp =
            VehicleInWithoutTempResponse.fromJson(withoutTempResponseBody);

      // print(withoutTempRequestBody);
      // print(withoutTempResponse.statusCode);
      // print(withoutTempResponse.body);
      logger.i('kdh201commuter');
      // logger.i(withoutTempRequestBody);
      // logger.i(withoutTempResponse.statusCode);
      // logger.i(withoutTempResponse.body);
      logger.i(withoutTempResponseBody);
      // print('GRYaris');
      logger.i('GRYaris');

      // if (withoutTempResponse.statusCode == 200) {
      //   final withoutTempResponseData = json.decode(withoutTempResponse.body);
      //   vehicleInWithoutTemp =
      //       VehicleInWithoutTempResponse.fromJson(withoutTempResponseData);
      //   print(
      //       'VehicleInWithoutTempProvider successful: $withoutTempResponseData');
      // } else {
      //   print('now in VehicleInWithTempProvider provider response line 4');
      //   throw Exception('Failed to VehicleInWithTempProvider');
      // }
    } catch (error) {
      print(
          'Error occurred in VehicleInWithTempProvider provider buhhhhhh: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
