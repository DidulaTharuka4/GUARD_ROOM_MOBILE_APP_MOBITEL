import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

void clearToken() async {
  var logger = Logger();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  logger.i('Token cleared');
}