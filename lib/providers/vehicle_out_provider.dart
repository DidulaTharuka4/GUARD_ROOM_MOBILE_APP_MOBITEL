import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/vehicle_out_with_temp_model.dart';
import 'package:Guard_Room_Application/models/vehicle_out_without_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

      final withTempResponseBody = await apiService.postRequest(
          url, withTempHeaders, withTempRequestBody);

      vehicleOutWithTemp =
          VehicleOutWithTempResponse.fromJson(withTempResponseBody);

      logger.i('vehicle out with temp response : ${withTempResponseBody}');
    } catch (error) {
      logger.i('Error occurred in Vehicle Out With Temp Provider : $error');
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

      final withoutTempResponseBody = await apiService.postRequest(
          url, withoutTempHeaders, withoutTempRequestBody);

      vehicleOutWithoutTemp =
          VehicleOutWithoutTempResponse.fromJson(withoutTempResponseBody);

      logger
          .i('vehicle out without temp response : ${withoutTempResponseBody}');
    } catch (error) {
      logger.i('Error occurred in Vehicle Out Without Temp Provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
