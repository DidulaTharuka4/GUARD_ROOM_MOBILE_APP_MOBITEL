import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sample_flutter_application_1/constraints/api_services.dart';
import 'package:sample_flutter_application_1/constraints/serviceURL.dart';
// import 'dart:convert';

import 'package:sample_flutter_application_1/constraints/token.dart';
import 'package:sample_flutter_application_1/models/end_attendance_with_temp_model.dart';
import 'package:sample_flutter_application_1/models/end_attendance_without_temp_model.dart';
import 'package:sample_flutter_application_1/constraints/headers.dart';

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


      // logger.i('kikikik');
      logger.i(withTempResponseBody);
      // logger.i('ererererere');
      // print(withTempResponse.statusCode);
      // print('iiiiiii');

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
      print('Eror occurred in EndAttendanceWithTempProvider provider: $error');
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

      // print('aaaaaaaa');
      logger.i('aaaaaaaa');
      // print(withoutTempRequestBody);
      logger.i(withoutTempResponseBody);
      // print(withoutTempResponse.statusCode);
      // print('llllll');
      logger.i('llllll');

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
      print('Error occurred in EndAttendanceWithTempProvider provider: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
