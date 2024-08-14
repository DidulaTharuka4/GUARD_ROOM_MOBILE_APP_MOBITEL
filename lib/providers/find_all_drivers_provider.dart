import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/find_all_drivers_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/find_all_drivers_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

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

      // final response = await http.post(
      //   Uri.parse(url),
      //   // headers: {
      //   //   'Content-Type': ' application/json',
      //   //   'Authorization': 'Bearer $token',
      //   //   'x-ibm-client-id': 'aaaebf5313c8edcb4ea735e5d890b6a3'
      //   // },
      //   headers: headers,
      //   body: json.encode({}),
      // );

      final responseBody =
          await apiService.postRequest(url, headers, allDriversRequestBody);

      getAllDrivers = FindAllDriversResponse.fromJson(responseBody);

      logger.i('all driver details : ${responseBody}');

      // if (response.statusCode == 200) {
      //   final responseData = json.decode(response.body);
      //   getAllDrivers = FindAllDriversResponse.fromJson(responseData);
      // } else {
      //   throw Exception('Failed to FindAllDriversProvider');
      // }
    } catch (error) {
      logger.i('Error occurred in Find All Drivers Provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchData() {}
}
