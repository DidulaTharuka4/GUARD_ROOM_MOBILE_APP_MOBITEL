import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/vehicle_in_with_temp_model.dart';
import 'package:Guard_Room_Application/models/vehicle_in_without_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

      final withTempResponseBody = await apiService.postRequest(
          url, withTempHeaders, withTempRequestBody);

      vehicleInWithTemp =
          VehicleInWithTempResponse.fromJson(withTempResponseBody);

      logger.i('vehicle in with temp response : ${withTempResponseBody}');
    } catch (error) {
      logger.i('Error occurred in Vehicle In With Temp Provider : $error');
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

      final withoutTempResponseBody = await apiService.postRequest(
          url, withoutTempHeaders, withoutTempRequestBody);

      vehicleInWithoutTemp =
          VehicleInWithoutTempResponse.fromJson(withoutTempResponseBody);

      logger.i('vehicle in without temp response : ${withoutTempResponseBody}');
    } catch (error) {
      logger.i('Error occurred in Vehicle In Without Temp Provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
