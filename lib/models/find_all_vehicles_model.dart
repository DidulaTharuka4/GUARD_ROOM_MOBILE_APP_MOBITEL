class FindAllVehiclesResponse {
    // final List<ErrorDetailsList> errorDetailsList;
    // final bool success;
    // final dynamic vehicleInOutRecordDtoList;
    // final dynamic vehicleAttendanceDtoList;
    // final dynamic guardRoomUserDtoList;
    // final dynamic vehicleAttendanceDto;
    // final dynamic appDriverMobileDtoList;
    // final List<AppVehicleMobileDtoList> appVehicleMobileDtoList;

    final List<ErrorDetailsList> errorDetailsList;
    final bool success;
    final List<dynamic>? vehicleInOutRecordDtoList;
    final List<dynamic>? vehicleAttendanceDtoList;
    final List<dynamic>? guardRoomUserDtoList;
    final dynamic vehicleAttendanceDto;
    final List<dynamic>? appDriverMobileDtoList;
    final List<AppVehicleMobileDtoList> appVehicleMobileDtoList;

    FindAllVehiclesResponse({
        required this.errorDetailsList,
        required this.success,
        required this.vehicleInOutRecordDtoList,
        required this.vehicleAttendanceDtoList,
        required this.guardRoomUserDtoList,
        required this.vehicleAttendanceDto,
        required this.appDriverMobileDtoList,
        required this.appVehicleMobileDtoList,
    });

  factory FindAllVehiclesResponse.fromJson(Map<String, dynamic> json) {
    return FindAllVehiclesResponse(
      errorDetailsList: (json['errorDetailsList'] as List)
          .map((i) => ErrorDetailsList.fromJson(i))
          .toList(),
      success: json['success'],
      vehicleInOutRecordDtoList: json['vehicleInOutRecordDtoList'],
      vehicleAttendanceDtoList: json['vehicleAttendanceDtoList'],
      guardRoomUserDtoList: json['guardRoomUserDtoList'],
      vehicleAttendanceDto: json['vehicleAttendanceDto'],
      appDriverMobileDtoList: json['appDriverMobileDtoList'],
      // appVehicleMobileDtoList: json['appVehicleMobileDtoList'],
       appVehicleMobileDtoList: (json['appVehicleMobileDtoList'] as List)
          .map((i) => AppVehicleMobileDtoList.fromJson(i))
          .toList(),
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
      'appVehicleMobileDtoList': appVehicleMobileDtoList.map((e) => e.toJson()).toList(),
    };
  }

}

class AppVehicleMobileDtoList {
    final int? id;
    final String? vehicleRegNumber;

    AppVehicleMobileDtoList({
        required this.id,
        required this.vehicleRegNumber,
    });

    factory AppVehicleMobileDtoList.fromJson(Map<String, dynamic> json) {
    return AppVehicleMobileDtoList(
      id: json['id'],
      vehicleRegNumber: json['vehicleRegNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleRegNumber': vehicleRegNumber,
    };
  }

}

class ErrorDetailsList {
    final String? timeStamp;
    final String? message;
    final String? code;
    final dynamic details;
    final bool? success;

    ErrorDetailsList({
        required this.timeStamp,
        required this.message,
        required this.code,
        required this.details,
        required this.success,
    });

    factory ErrorDetailsList.fromJson(Map<String, dynamic> json) {
    return ErrorDetailsList(
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
