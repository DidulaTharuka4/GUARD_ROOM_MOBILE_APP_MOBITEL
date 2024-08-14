import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/login_authentication.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_Services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/login_authentication.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

class LoginProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  LoginResponse? responseToRequest;

  String? get token => _token;
  bool get isLoading => _isLoading;
  LoginResponse? get loginresponse => responseToRequest;

  var logger = Logger();

  final ApiServices apiService = ApiServices();
  
  Future<void> fetchLogin(body) async {
    const url = ApplicationServices.loginUrl;
    final headers = Headers(null);
    final loginRequestBody = body;

    try {
      _isLoading = true;
      notifyListeners();

      // final response = await http.post(
      //   Uri.parse(url),
      //   headers: headers,
      //   body: json.encode(loginRequestBody),
      // );

      final responseBody = await apiService.postRequest(url, headers, loginRequestBody);

      // print(response.statusCode);
      // logger.i('dan inne provider eke  1 ${response}');
      // logger.i('dan inne provider eke 2 ${responseBody}');
      // print(response.body);

      responseToRequest = LoginResponse.fromJson(responseBody);
      final token = responseBody['jwttoken'];
        saveToken(token);

      logger.i('login response details : ${responseToRequest}');


      // if (response.statusCode == 200) {
      //   final responseData = json.decode(response.body);
      //   responseToRequest = LoginResponse.fromJson(responseData);
        

      //   final token = responseData['jwttoken'];
      //   saveToken(token);
      // } else {
      //   throw Exception('Failed to login');
      // }
    } catch (error) {
      logger.i('Error occurred in login provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
