import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/end_attendance_with_temp_model.dart';
import 'package:Guard_Room_Application/models/end_attendance_without_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EndAttendanceProvider with ChangeNotifier {
  var logger = Logger();
  String? _token;
  bool _isLoading = false;
  EndAttendanceWithTempResponse? endPostAttendanceWithTemp;
  EndAttendanceWithoutTempResponse? endPostAttendanceWithoutTemp;

  String? get token => _token;
  bool get isLoading => _isLoading;
  EndAttendanceWithTempResponse? get endAttendanceWithTempResponse =>
      endPostAttendanceWithTemp;
  EndAttendanceWithoutTempResponse? get endAttendanceWithoutTempResponse =>
      endPostAttendanceWithoutTemp;

  final ApiServices apiService = ApiServices();

  Future<void> EndAttendanceWithTemp(getEndAttendanceWIthTemp) async {
    const url = ApplicationServices.endAttendanceUrl;
    final token = await getToken();
    final withTempRequestBody = getEndAttendanceWIthTemp;
    final withTempHeaders = Headers(token);

    try {
      _isLoading = true;
      notifyListeners();

      final withTempResponseBody = await apiService.postRequest(
          url, withTempHeaders, withTempRequestBody);

      endPostAttendanceWithTemp =
          EndAttendanceWithTempResponse.fromJson(withTempResponseBody);

      logger.i('end attendance with temp response : ${withTempResponseBody}');
    } catch (error) {
      print('Eror occurred in End Attendance With Temp Provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //-------------------------------------------------------------------------------

  Future<void> EndAttendanceWithoutTemp(getEndAttendanceWIthoutTemp) async {
    const url = ApplicationServices.endAttendanceUrl;
    final token = await getToken();
    final withoutTempRequestBody = getEndAttendanceWIthoutTemp;
    final withoutTempHeaders = Headers(token);

    try {
      _isLoading = true;
      notifyListeners();

      final withoutTempResponseBody = await apiService.postRequest(
          url, withoutTempHeaders, withoutTempRequestBody);

      endPostAttendanceWithoutTemp =
          EndAttendanceWithoutTempResponse.fromJson(withoutTempResponseBody);

      logger.i(
          'end attendance without temp response : ${withoutTempResponseBody}');
    } catch (error) {
      logger
          .i('Error occurred in End Attendance Without Temp Provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
