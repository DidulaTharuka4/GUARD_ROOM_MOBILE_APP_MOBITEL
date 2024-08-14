import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/find_all_vehicles_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/find_all_vehicles_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

class FindAllVehiclesProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  FindAllVehiclesResponse? getAllVehicles;

  String? get token => _token;
  bool get isLoading => _isLoading;
  FindAllVehiclesResponse? get findAllVehiclesResponse =>
      getAllVehicles;

  final ApiServices apiService = ApiServices();

  Future<void> findAllVehicles() async {
    const url = ApplicationServices.getAllVehiclesUrl;
    final token = await getToken();
    final headers = Headers(token);
    final allVehiclesRequestBody = {};

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
          await apiService.postRequest(url, headers, allVehiclesRequestBody);

      getAllVehicles =
            FindAllVehiclesResponse.fromJson(responseBody);

      logger.i('all vehicle details : ${responseBody}');

      // if (response.statusCode == 200) {
      //   final responseData = json.decode(response.body);
      //   getAllVehicles =
      //       FindAllVehiclesResponse.fromJson(responseData);
      // } else {
      //   throw Exception('Failed to FindAllVehiclesProvider');
      // }
    } catch (error) {
      logger.i('Error occurred in Find All Vehicles Provider provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
