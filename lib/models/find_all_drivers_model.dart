class FindAllDriversResponse {
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
    final List<AppDriverMobileDtoList> appDriverMobileDtoList;
    final List<dynamic>? appVehicleMobileDtoList;

    FindAllDriversResponse({
        required this.errorDetailsList,
        required this.success,
        required this.vehicleInOutRecordDtoList,
        required this.vehicleAttendanceDtoList,
        required this.guardRoomUserDtoList,
        required this.vehicleAttendanceDto,
        required this.appDriverMobileDtoList,
        required this.appVehicleMobileDtoList,
    });

  factory FindAllDriversResponse.fromJson(Map<String, dynamic> json) {
    return FindAllDriversResponse(
      errorDetailsList: (json['errorDetailsList'] as List)
          .map((i) => ErrorDetailsList.fromJson(i))
          .toList(),
      // errorDetailsList: ErrorDetailsList.fromJson(json['errorDetailsList']),
      success: json['success'],
      vehicleInOutRecordDtoList: json['vehicleInOutRecordDtoList'],
      vehicleAttendanceDtoList: json['vehicleAttendanceDtoList'],
      guardRoomUserDtoList: json['guardRoomUserDtoList'],
      vehicleAttendanceDto: json['vehicleAttendanceDto'],
      // appDriverMobileDtoList: json['appDriverMobileDtoList'],
      appDriverMobileDtoList: (json['appDriverMobileDtoList'] as List)
          .map((i) => AppDriverMobileDtoList.fromJson(i))
          .toList(),
      // appDriverMobileDtoList: AppDriverMobileDtoList.fromJson(json['appDriverMobileDtoList']),
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
      'appDriverMobileDtoList': appDriverMobileDtoList.map((e) => e.toJson()).toList(),
      'appVehicleMobileDtoList': appVehicleMobileDtoList,
    };
  }

}

class AppDriverMobileDtoList {
    final int? id;
    final String? nic;
    final String? licenseNum;
    final String? cname;


    AppDriverMobileDtoList({
        required this.id,
        required this.nic,
        required this.licenseNum,
        required this.cname,
    });

    factory AppDriverMobileDtoList.fromJson(Map<String, dynamic> json) {
    return AppDriverMobileDtoList(
      id: json['id'],
      nic: json['nic'],
      licenseNum: json['licenseNum'],
      cname: json['cname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nic': nic,
      'licenseNum': licenseNum,
      'cname': cname,
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
