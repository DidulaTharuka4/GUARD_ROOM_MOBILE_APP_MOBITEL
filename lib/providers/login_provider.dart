import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/login_authentication.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

      final responseBody =
          await apiService.postRequest(url, headers, loginRequestBody);

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
