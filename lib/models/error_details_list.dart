class ErrorDetails {
  String timeStamp;
  String message;
  String code;
  String? details;
  bool success;

  ErrorDetails({
    required this.timeStamp,
    required this.message,
    required this.code,
    this.details,
    required this.success,
  });

  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      timeStamp: json['timeStamp'],
      message: json['message'],
      code: json['code'],
      details: json['details'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeStamp': timeStamp,
      'message': message,
      'code': code,
      'details': details,
      'success': success,
    };
  }
}