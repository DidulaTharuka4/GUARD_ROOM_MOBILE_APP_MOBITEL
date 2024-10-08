import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class ApiServices {
  var logger = Logger();

  // Get Request ----------------------------------------
  Future<dynamic> getRequest(url, headers, body) async {
    final getRequestResponse = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    return responseHandling(getRequestResponse);
  }

  // Post Request ----------------------------------------
  Future<dynamic> postRequest(url, headers, body) async {
    final postRequestResponse = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    logger.i('request body : ${body}');
    logger.i('response body : ${postRequestResponse.body}');

    return responseHandling(postRequestResponse);
  }

  // Response Error Handling--------------------------------------
  dynamic responseHandling(http.Response response) {
    switch (response.statusCode) {
      case 200:
        logger.i('Response Body: ${response.body}');
        return json.decode(response.body);
      case 400:
        logger.i('Bad Request: ${response.body}');
        throw Exception('Bad Request: ${response.body}');
      case 401:
      case 403:
        logger.i('Unauthorized: ${response.body}');
        throw Exception('Unauthorized: ${response.body}');
      case 500:
      default:
        logger.i(
            'Error occurred while communicating with the server: ${response.body}');
        throw Exception(
            'Error occurred while communicating with the server: ${response.body}');
    }
  }
}
