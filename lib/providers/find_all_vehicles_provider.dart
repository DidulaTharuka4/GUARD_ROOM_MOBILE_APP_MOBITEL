import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/find_all_vehicles_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FindAllVehiclesProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  FindAllVehiclesResponse? getAllVehicles;

  String? get token => _token;
  bool get isLoading => _isLoading;
  FindAllVehiclesResponse? get findAllVehiclesResponse => getAllVehicles;

  final ApiServices apiService = ApiServices();

  Future<void> findAllVehicles() async {
    const url = ApplicationServices.getAllVehiclesUrl;
    final token = await getToken();
    final headers = Headers(token);
    final allVehiclesRequestBody = {};

    try {
      _isLoading = true;
      notifyListeners();

      final responseBody =
          await apiService.postRequest(url, headers, allVehiclesRequestBody);

      getAllVehicles = FindAllVehiclesResponse.fromJson(responseBody);

      logger.i('all vehicle details : ${responseBody}');
    } catch (error) {
      logger.i('Error occurred in Find All Vehicles Provider provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
