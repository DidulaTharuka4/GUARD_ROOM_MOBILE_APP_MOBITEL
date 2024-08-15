class VehicleInWithoutTempResponse {
  final List<ErrorDetails> errorDetailsList;
  final bool success;
  final List<dynamic>? vehicleInOutRecordDtoList;
  final List<dynamic>? vehicleAttendanceDtoList;
  final List<dynamic>? guardRoomUserDtoList;
  final List<dynamic>? vehicleAttendanceDto;
  // final dynamic vehicleAttendanceDto;
  final List<dynamic>? appDriverMobileDtoList;
  final List<dynamic>? appVehicleMobileDtoList;

  VehicleInWithoutTempResponse({
    required this.errorDetailsList,
    required this.success,
    this.vehicleInOutRecordDtoList,
    this.vehicleAttendanceDtoList,
    this.guardRoomUserDtoList,
    this.vehicleAttendanceDto,
    this.appDriverMobileDtoList,
    this.appVehicleMobileDtoList,
  });

  factory VehicleInWithoutTempResponse.fromJson(Map<String, dynamic> json) {
    return VehicleInWithoutTempResponse(
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
