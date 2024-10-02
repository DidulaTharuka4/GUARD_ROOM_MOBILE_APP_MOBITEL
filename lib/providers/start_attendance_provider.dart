import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/start_attendance_with_temp_model.dart';
import 'package:Guard_Room_Application/models/start_attendance_without_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
      final withTempResponseBody = await apiService.postRequest(
          url, withTempHeaders, withTempRequestBody);

      startPostAttendanceWithTemp =
          StartAttendanceWithTempResponse.fromJson(withTempResponseBody);

      logger.i('start attendance with temp response : ${withTempResponseBody}');
    } catch (error) {
      logger
          .i('Error occurred in start Attendance With Temp provider : $error');
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

      final withoutTempResponseBody = await apiService.postRequest(
          url, withoutTempHeaders, withoutTempRequestBody);

      startPostAttendanceWithoutTemp =
          StartAttendanceWithoutTempResponse.fromJson(withoutTempResponseBody);

      logger.i(
          'start attendance without temp response : ${withoutTempResponseBody}');
    } catch (error) {
      logger.i(
          'Error occurred in start attendance without temp provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
