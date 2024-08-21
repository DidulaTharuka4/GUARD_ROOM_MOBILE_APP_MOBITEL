// import 'dart:convert';

class FindAllVehiclesResponse  {
  List<ErrorDetails>? errorDetailsList;
  bool? success;
  final List<dynamic>? vehicleInOutRecordDtoList;
  final List<dynamic>? vehicleAttendanceDtoList;
  final List<dynamic>? guardRoomUserDtoList;
  // final List<dynamic>? vehicleAttendanceDto;
  final dynamic vehicleAttendanceDto;
  final List<dynamic>? appDriverMobileDtoList;
  List<AppVehicleMobileDto>? appVehicleMobileDtoList;

  FindAllVehiclesResponse ({
    this.errorDetailsList,
    this.success,
    required this.vehicleInOutRecordDtoList,
    required this.vehicleAttendanceDtoList,
    required this.guardRoomUserDtoList,
    required this.vehicleAttendanceDto,
    required this.appDriverMobileDtoList,
    this.appVehicleMobileDtoList,
  });

  // Factory constructor to create an instance of ApiResponse from JSON
  factory FindAllVehiclesResponse .fromJson(Map<String, dynamic> json) {
    return FindAllVehiclesResponse (
      errorDetailsList: (json['errorDetailsList'] as List<dynamic>?)
          ?.map((e) => ErrorDetails.fromJson(e))
          .toList(),
      success: json['success'],
      vehicleInOutRecordDtoList: json['vehicleInOutRecordDtoList'],
      vehicleAttendanceDtoList: json['vehicleAttendanceDtoList'],
      guardRoomUserDtoList: json['guardRoomUserDtoList'],
      vehicleAttendanceDto: json['vehicleAttendanceDto'],
      appDriverMobileDtoList: json['appDriverMobileDtoList'],
      // appVehicleMobileDtoList: json['appVehicleMobileDtoList'],
      appVehicleMobileDtoList: (json['appVehicleMobileDtoList'] as List<dynamic>?)
          ?.map((e) => AppVehicleMobileDto.fromJson(e))
          .toList(),
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'errorDetailsList': errorDetailsList?.map((e) => e.toJson()).toList(),
      'success': success,
      'vehicleInOutRecordDtoList': vehicleInOutRecordDtoList,
      'vehicleAttendanceDtoList': vehicleAttendanceDtoList,
      'guardRoomUserDtoList': guardRoomUserDtoList,
      'vehicleAttendanceDto': vehicleAttendanceDto,
      'appDriverMobileDtoList': appDriverMobileDtoList,
      'appVehicleMobileDtoList': appVehicleMobileDtoList?.map((e) => e.toJson()).toList(),
    };
  }
}

class ErrorDetails {
  String? timeStamp;
  String? message;
  String? code;
  String? details;
  bool? success;

  ErrorDetails({
    this.timeStamp,
    this.message,
    this.code,
    this.details,
    this.success,
  });

  // Factory constructor to create an instance of ErrorDetails from JSON
  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      timeStamp: json['timeStamp'],
      message: json['message'],
      code: json['code'],
      details: json['details'],
      success: json['success'],
    );
  }

  // Method to convert the model back to JSON
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

class AppVehicleMobileDto {
  int? id;
  String? vehicleRegNumber;
  DriverDto? driverDto;

  AppVehicleMobileDto({
    this.id,
    this.vehicleRegNumber,
    this.driverDto,
  });

  // Factory constructor to create an instance of AppVehicleMobileDto from JSON
  factory AppVehicleMobileDto.fromJson(Map<String, dynamic> json) {
    return AppVehicleMobileDto(
      id: json['id'],
      vehicleRegNumber: json['vehicleRegNumber'],
      driverDto: json['driverDto'] != null ? DriverDto.fromJson(json['driverDto']) : null,
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleRegNumber': vehicleRegNumber,
      'driverDto': driverDto?.toJson(),
    };
  }
}

class DriverDto {
  int? id;
  String? nic;
  String? licenseNum;
  String? cname;

  DriverDto({
    this.id,
    this.nic,
    this.licenseNum,
    this.cname,
  });

  // Factory constructor to create an instance of DriverDto from JSON
  factory DriverDto.fromJson(Map<String, dynamic> json) {
    return DriverDto(
      id: json['id'],
      nic: json['nic'],
      licenseNum: json['licenseNum'],
      cname: json['cname'],
    );
  }

  // Method to convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nic': nic,
      'licenseNum': licenseNum,
      'cname': cname,
    };
  }
}
