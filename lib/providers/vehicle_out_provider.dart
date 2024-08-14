import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/vehicle_out_with_temp_model.dart';
import 'package:Guard_Room_Application/models/vehicle_out_without_temp_model.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
import 'package:logger/logger.dart';

// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/vehicle_out_with_temp_model.dart';
// import 'package:sample_flutter_application_1/models/vehicle_out_without_temp_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

class VehicleOutProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  VehicleOutWithTempResponse? vehicleOutWithTemp;
  VehicleOutWithoutTempResponse? vehicleOutWithoutTemp;

  String? get token => _token;
  bool get isLoading => _isLoading;
  VehicleOutWithTempResponse? get vehicleOutWithTempResponse =>
      vehicleOutWithTemp;
  VehicleOutWithoutTempResponse? get vehicleOutWithoutTempResponse =>
      vehicleOutWithoutTemp;

  final ApiServices apiService = ApiServices();

  Future<void> VehicleOutWithTemp(getVehicleOutWithTemp) async {
    const url = ApplicationServices.vehicleInOutUrl;
    final token = await getToken();
    final withTempRequestBody = getVehicleOutWithTemp;
    final withTempHeaders = Headers(token);

    try {
      _isLoading = true;
      notifyListeners();

      // final withTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withTempHeaders,
      //   body: json.encode(withTempRequestBody),
      // );

      final withTempResponseBody = await apiService.postRequest(
          url, withTempHeaders, withTempRequestBody);

      vehicleOutWithTemp =
          VehicleOutWithTempResponse.fromJson(withTempResponseBody);

      // print(withTempResponse.statusCode);
      // logger.i(withTempResponse.statusCode);
      // print(withTempRequestBody);
      // logger.i(withTempRequestBody);
      // print('awasanaya');
      logger.i('wewewewew');
      // print(withTempResponse.body);
      // logger.i(withTempResponse.body);
      logger.i(withTempResponseBody);
      logger.i('awasanaya');


      // if (withTempResponse.statusCode == 200) {
      //   final withTempResponseData = json.decode(withTempResponse.body);
      //   vehicleOutWithTemp =
      //       VehicleOutWithTempResponse.fromJson(withTempResponseData);
      //   print('VehicleOutWithTempProvider successful: $withTempResponseData');
      // } else {
      //   print('now in VehicleOutWithTempProvider provider response line 4');
      //   throw Exception('Failed to VehicleOutWithTempProvider');
      // }
    } catch (error) {
      print(
          'Error occurred in VehicleOutWithTempProvider providerrrrr: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //-------------------------------------------------------------------------------------

  Future<void> VehicleOutWithoutTemp(getVehicleOutWithoutTemp) async {
    const url = ApplicationServices.vehicleInOutUrl;
    final token = await getToken();
    final withoutTempRequestBody = getVehicleOutWithoutTemp;
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

      vehicleOutWithoutTemp =
            VehicleOutWithoutTempResponse.fromJson(withoutTempResponseBody);

      // print('ok ok ok');
      logger.i('ok ok ok');
      // print(withoutTempRequestBody);
      // logger.i(withoutTempRequestBody);
      // print(withoutTempResponse.body);
      // logger.i(withoutTempResponse.body);
      // print(withoutTempResponse.statusCode);
      // logger.i(withoutTempResponse.statusCode);
      logger.i(withoutTempResponseBody);
      // print('ko ko ko');
      logger.i('ko ko ko');

      // if (withoutTempResponse.statusCode == 200) {
      //   final withoutTempResponseData = json.decode(withoutTempResponse.body);
      //   vehicleOutWithoutTemp =
      //       VehicleOutWithoutTempResponse.fromJson(withoutTempResponseData);
      //   print(
      //       'VehicleOutWithoutTempResponse successful 1: ${withoutTempResponse.body}');
      //   print(
      //       'VehicleOutWithoutTempResponse successful 2: ${withoutTempResponseData}');
      // } else {
      //   print('now in VehicleOutWithTempProvider provider response line 4');
      //   throw Exception('Failed to VehicleOutWithTempProvider');
      // }
    } catch (error) {
      print('Error occurred in VehicleOutWithoutTempProvider provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
