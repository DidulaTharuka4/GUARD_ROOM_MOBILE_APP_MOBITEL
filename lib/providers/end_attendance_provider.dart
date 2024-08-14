import 'package:Guard_Room_Application/constraints/api_services.dart';
import 'package:Guard_Room_Application/constraints/headers.dart';
import 'package:Guard_Room_Application/constraints/serviceURL.dart';
import 'package:Guard_Room_Application/constraints/token.dart';
import 'package:Guard_Room_Application/models/end_attendance_with_temp_model.dart';
import 'package:Guard_Room_Application/models/end_attendance_without_temp_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:http/http.dart' as http;
// import 'package:sample_flutter_application_1/constraints/api_services.dart';
// import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';
// import 'package:sample_flutter_application_1/constraints/token.dart';
// import 'package:sample_flutter_application_1/models/end_attendance_with_temp_model.dart';
// import 'package:sample_flutter_application_1/models/end_attendance_without_temp_model.dart';
// import 'package:sample_flutter_application_1/constraints/headers.dart';

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

      // final withTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withTempHeaders,
      //   body: json.encode(withTempRequestBody),
      // );

      final withTempResponseBody =
          await apiService.postRequest(url, withTempHeaders, withTempRequestBody);

      endPostAttendanceWithTemp =
            EndAttendanceWithTempResponse.fromJson(withTempResponseBody);


      logger.i('end attendance with temp response : ${withTempResponseBody}');

      // if (withTempResponse.statusCode == 200) {
      //   final withTempResponseData = json.decode(withTempResponse.body);
      //   endPostAttendanceWithTemp =
      //       EndAttendanceWithTempResponse.fromJson(withTempResponseData);
      //   print(
      //       'EndAttendanceWithTempProvider successful: $withTempResponseData');
      // } else {
      //   throw Exception('Failed to EndAttendanceWithTempProvider');
      // }
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

      // final withoutTempResponse = await http.post(
      //   Uri.parse(url),
      //   headers: withoutTempHeaders,
      //   body: json.encode(withoutTempRequestBody),
      // );

      final withoutTempResponseBody =
          await apiService.postRequest(url, withoutTempHeaders, withoutTempRequestBody);

      endPostAttendanceWithoutTemp =
            EndAttendanceWithoutTempResponse.fromJson(withoutTempResponseBody);

      logger.i('end attendance without temp response : ${withoutTempResponseBody}');

      // if (withoutTempResponse.statusCode == 200) {
      //   final withoutTempResponseData = json.decode(withoutTempResponse.body);
      //   endPostAttendanceWithoutTemp =
      //       EndAttendanceWithoutTempResponse.fromJson(withoutTempResponseData);
      //   print(
      //       'EndAttendanceWithTempProvider successful: $withoutTempResponseData');
      // } else {
      //   throw Exception('Failed to EndAttendanceWithTempProvider');
      // }
    } catch (error) {
      logger.i('Error occurred in End Attendance Without Temp Provider : $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
