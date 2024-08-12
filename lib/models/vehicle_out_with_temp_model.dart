class VehicleOutWithTempResponse {
  List<ErrorDetails> errorDetailsList;
  bool success;
  List<dynamic>? vehicleInOutRecordDtoList;
  List<dynamic>? vehicleAttendanceDtoList;
  List<dynamic>? guardRoomUserDtoList;
  List<dynamic>? vehicleAttendanceDto;
  List<dynamic>? appDriverMobileDtoList;
  List<dynamic>? appVehicleMobileDtoList;

  VehicleOutWithTempResponse({
    required this.errorDetailsList,
    required this.success,
    required this.vehicleInOutRecordDtoList,
    required this.vehicleAttendanceDtoList,
    required this.guardRoomUserDtoList,
    required this.vehicleAttendanceDto,
    required this.appDriverMobileDtoList,
    required this.appVehicleMobileDtoList,
  });

  factory VehicleOutWithTempResponse.fromJson(Map<String, dynamic> json) {
    return VehicleOutWithTempResponse(
      errorDetailsList: (json['errorDetailsList'] as List)
          .map((i) => ErrorDetails.fromJson(i))
          .toList(),
      success: json['success'],
      vehicleInOutRecordDtoList: json['vehicleInOutRecordDtoList'],
      vehicleAttendanceDtoList: json['vehicleAttendanceDtoList'],
      guardRoomUserDtoList: json['guardRoomUserDtoList'],
      vehicleAttendanceDto: json['vehicleAttendanceDto'],
      appDriverMobileDtoList: json['appDriverMobileDtoList'],
      appVehicleMobileDtoList: json['appVehicleMobileDtoList'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorDetailsList': errorDetailsList.map((e) => e.toJson()).toList(),
      'success': success,
      'vehicleInOutRecordDtoList': vehicleInOutRecordDtoList,
      'vehicleAttendanceDtoList': vehicleAttendanceDtoList,
      'guardRoomUserDtoList': guardRoomUserDtoList,
      'vehicleAttendanceDto': vehicleAttendanceDto,
      'appDriverMobileDtoList': appDriverMobileDtoList,
      'appVehicleMobileDtoList': appVehicleMobileDtoList,
    };
  }
}

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
