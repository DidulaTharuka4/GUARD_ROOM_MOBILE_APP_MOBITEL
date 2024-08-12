// Login
Map<String, dynamic> getLoginRequestBody(username, password) {
  return {
    'username': username,
    'password': password,
  };
}

// Vehicle Details
Map<String, dynamic> getAllVehicleDetails() {
  return {};
}

// Driver Details
Map<String, dynamic> getAllDriverDetails() {
  return {};
}

// Attendance Details
// Start
Map<String, dynamic> getStartAttendanceWIthTemp(
    vehicleID,
    driverID,
    mileage,
    userID,
    userName,
    replaceVehicleNumber,
    replaceDriverNIC,
    replaceComment,
    dateTime) {
  return {
    'vehicleAttendanceDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'tempVehicleNo': replaceVehicleNumber,
      'tempDriverNic': replaceDriverNIC,
      'gateStartTime': dateTime,
      'addedBy': userID,
      'startComment': replaceComment,
      'startOfficer': userName,
      'startMileage': mileage
    }
  };
}

Map<String, dynamic> getStartAttendanceWIthoutTemp(
    vehicleID, driverID, mileage, userID, userName, dateTime) {
  return {
    'vehicleAttendanceDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'gateStartTime': dateTime,
      'addedBy': userID,
      'startComment': 'Start Comment',
      'startOfficer': userName,
      'startMileage': mileage,
    }
  };
}

// End
Map<String, dynamic> getEndAttendanceWIthTemp(
    vehicleID,
    driverID,
    mileage,
    userName,
    replaceVehicleNumber,
    replaceDriverNIC,
    replaceComment,
    dateTime) {
  return {
    'vehicleAttendanceDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'tempVehicleNo': replaceVehicleNumber,
      'tempDriverNic': replaceDriverNIC,
      'gateEndTime': dateTime,
      'endComment': replaceComment,
      'endOfficer': userName,
      'endMileage': mileage
    }
  };
}

Map<String, dynamic> getEndAttendanceWIthoutTemp(
    vehicleID, driverID, mileage, userName, dateTime) {
  return {
    'vehicleAttendanceDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'gateEndTime': dateTime,
      'endComment': 'End comments',
      'endOfficer': userName,
      'endMileage': mileage
    }
  };
}

// Trip Details
// Vehicle In
Map<String, dynamic> getVehicleInWIthTemp(vehicleID, driverID, mileage, userID,
    userName, tempVehicleNumber, tempDriverNIC, tempComment, dateTime, tripID) {
  return {
    'vehicleInOutRecordDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'tempVehicleNo': tempVehicleNumber,
      'tempDriverNic': tempDriverNIC,
      'recordTime': dateTime,
      'addedBy': 1,
      'comment': tempComment,
      'officer': userName,
      'type': 'IN',
      'tripId': tripID,
      'mileage': mileage
    }
  };
}

Map<String, dynamic> getVehicleInWIthoutTemp(
    vehicleID, driverID, mileage, userID, userName, dateTime, tripID) {
  return {
    'vehicleInOutRecordDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'recordTime': dateTime,
      'addedBy': userID,
      'comment': 'No comments',
      'officer': userName,
      'type': 'IN',
      'tripId': tripID,
      'mileage': mileage
    }
  };
}

// Vehicle Out
Map<String, dynamic> getVehicleOutWIthTemp(vehicleID, driverID, mileage, userID,
    userName, tempVehicleNumber, tempDriverNIC, tempComment, dateTime, tripID) {
  return {
    'vehicleInOutRecordDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'tempVehicleNo': tempVehicleNumber,
      'tempDriverNic': tempDriverNIC,
      'recordTime': dateTime,
      'addedBy': userID,
      'comment': 'No comments',
      'officer': userName,
      'type': 'OUT',
      'tripId': tripID,
      'mileage': mileage
    }
  };
}

Map<String, dynamic> getVehicleOutWIthoutTemp(
    vehicleID, driverID, mileage, userName, userID, dateTime, tripID) {
  return {
    'vehicleInOutRecordDto': {
      'vehicleId': vehicleID,
      'driverId': driverID,
      'recordTime': dateTime,
      'addedBy': userID,
      'comment': 'Out comments',
      'officer': userName,
      'type': 'OUT',
      'tripId': tripID,
      'mileage': mileage
    }
  };
}
