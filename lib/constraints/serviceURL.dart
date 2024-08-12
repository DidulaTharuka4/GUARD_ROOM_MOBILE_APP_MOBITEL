class ApplicationServices {
  static const mainUrl = 'https://apphubstg.mobitel.lk/mobitelint/mapis/mtransport-guard-room-services/';

  static const login = 'authenticate';
  static const startAttendance = 'startVehicleAttendance';
  static const endAttendance = 'endVehicleAttendance';
  static const vehicleInOut = 'createVehicleInOut';
  static const getAllVehicles = 'getAllVehicles';
  static const getAllDrivers = 'getAllDrivers';

  // static const loginUrl = mainUrl + 'authenticate';
  static const loginUrl = '$mainUrl$login';
  static const startAttendanceUrl = '$mainUrl$startAttendance';
  static const endAttendanceUrl = '$mainUrl$endAttendance';
  static const vehicleInOutUrl = '$mainUrl$vehicleInOut';
  static const getAllVehiclesUrl = '$mainUrl$getAllVehicles';
  static const getAllDriversUrl = '$mainUrl$getAllDrivers';
}

