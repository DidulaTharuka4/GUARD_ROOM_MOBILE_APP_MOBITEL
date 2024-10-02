import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/find_all_drivers_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FindAllDriversProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  FindAllDriversResponse? getAllDrivers;

  String? get token => _token;
  bool get isLoading => _isLoading;
  FindAllDriversResponse? get findAllDriversResponse => getAllDrivers;

  get data => null;

  final ApiServices apiService = ApiServices();

  Future<void> findAllDrivers() async {
    const url = ApplicationServices.getAllDriversUrl;
    final token = await getToken();
    final headers = Headers(token);
    final allDriversRequestBody = {};

    try {
      _isLoading = true;
      notifyListeners();

      final responseBody =
          await apiService.postRequest(url, headers, allDriversRequestBody);

      getAllDrivers = FindAllDriversResponse.fromJson(responseBody);

      logger.i('all driver details : ${responseBody}');
    } catch (error) {
      logger.i('Error occurred in Find All Drivers Provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
