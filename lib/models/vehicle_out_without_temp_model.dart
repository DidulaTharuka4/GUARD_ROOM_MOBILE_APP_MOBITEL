class VehicleOutWithoutTempResponse {
  List<ErrorDetails> errorDetailsList;
  bool success;
  List<dynamic>? vehicleInOutRecordDtoList;
  List<dynamic>? vehicleAttendanceDtoList;
  List<dynamic>? guardRoomUserDtoList;
  dynamic vehicleAttendanceDto;
  List<dynamic>? appDriverMobileDtoList;
  List<dynamic>? appVehicleMobileDtoList;

  VehicleOutWithoutTempResponse({
    required this.errorDetailsList,
    required this.success,
    this.vehicleInOutRecordDtoList,
    this.vehicleAttendanceDtoList,
    this.guardRoomUserDtoList,
    this.vehicleAttendanceDto,
    this.appDriverMobileDtoList,
    this.appVehicleMobileDtoList,
  });

  factory VehicleOutWithoutTempResponse.fromJson(Map<String, dynamic> json) {
    return VehicleOutWithoutTempResponse(
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
