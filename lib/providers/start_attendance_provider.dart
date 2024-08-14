import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/start_attendance_with_temp_model.dart';
import 'package:Guard_Room_Application/models/start_attendance_without_temp_model.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
import 'package:logger/logger.dart';

// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/start_attendance_with_temp_model.dart';
// import 'package:sample_flutter_application_1/models/start_attendance_without_temp_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

class StartAttendanceProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  StartAttendanceWithTempResponse? startPostAttendanceWithTemp;
  StartAttendanceWithoutTempResponse? startPostAttendanceWithoutTemp;

  String? get token => _token;
  bool get isLoading => _isLoading;
  StartAttendanceWithTempResponse? get startAttendanceWithTempResponse =>
      startPostAttendanceWithTemp;
  StartAttendanceWithoutTempResponse? get startAttendanceWithoutTempResponse =>
      startPostAttendanceWithoutTemp;

  final ApiServices apiService = ApiServices();

  Future<void> startAttendanceWithTemp(getStartAttendanceWIthTemp) async {
    const url = ApplicationServices.startAttendanceUrl;
    final token = await getToken();
    final withTempRequestBody = getStartAttendanceWIthTemp;
    final withTempHeaders = Headers(token);

    try {

      // final withTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withTempHeaders,
      //   body: json.encode(withTempRequestBody),
      // );

      // logger.i(url);
      // logger.i(withTempHeaders);
      logger.i(withTempRequestBody);
      // logger.i('oooooo');

      final withTempResponseBody =
          await apiService.postRequest(url, withTempHeaders, withTempRequestBody);

      startPostAttendanceWithTemp =
            StartAttendanceWithTempResponse.fromJson(withTempResponseBody);

      // print(withTempResponse.statusCode);
      // print(withTempResponseBody);
      logger.i(withTempResponseBody);
      // logger.i(withTempResponse.statusCode);
      // print(withTempResponse.body);
      // logger.i(withTempResponse.body);
      // print('oooooo');
      // logger.i('oooooo');

      // if (withTempResponse.statusCode == 200) {
      //   final withTempResponseData = json.decode(withTempResponse.body);
      //   startPostAttendanceWithTemp =
      //       StartAttendanceWithTempResponse.fromJson(withTempResponseData);
      // } else {
      //   throw Exception('Failed to AttendanceWithTempProvider');
      // }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// -----------------------------------------------------------------------------------------------------

  Future<void> startAttendanceWithoutTemp(getStartAttendanceWIthoutTemp) async {
    const url = ApplicationServices.startAttendanceUrl;
    final token = await getToken();
    final withoutTempRequestBody = getStartAttendanceWIthoutTemp;
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

      startPostAttendanceWithoutTemp =
            StartAttendanceWithoutTempResponse.fromJson(
                withoutTempResponseBody);

      logger.i('veeee');

      // print(withoutTempResponse.statusCode);
      // logger.i(withoutTempResponse.statusCode);
      logger.i(withoutTempResponseBody);
      logger.i('this is att');
      // print(withoutTempResponse.body);
      // logger.i(withoutTempResponse.body);

      // if (withoutTempResponse.statusCode == 200) {
      //   final withoutTempResponseData = json.decode(withoutTempResponse.body);
      //   startPostAttendanceWithoutTemp =
      //       StartAttendanceWithoutTempResponse.fromJson(
      //           withoutTempResponseData);
      // } else {
      //   throw Exception('Failed to AttendanceWithTempProvider');
      // }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
