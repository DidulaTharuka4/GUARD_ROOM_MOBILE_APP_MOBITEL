import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  // String _token = false;
  bool _isLoading = false;

  // String get token => _token;
  bool get isLoading => _isLoading;

  set token(String value) {
    // _token = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
