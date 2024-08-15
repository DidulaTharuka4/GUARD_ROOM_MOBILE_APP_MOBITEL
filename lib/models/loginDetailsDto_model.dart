class LoginDetailsDto {
  final int userId;
  final String userName;
  final String? companyId;
  final String? roleCode;
  final String? designation;
  final String? fullName;
  final String? mobileNo;
  final String? division;
  final String? empNo;

  LoginDetailsDto({
    required this.userId,
    required this.userName,
    this.companyId,
    this.roleCode,
    this.designation,
    this.fullName,
    this.mobileNo,
    this.division,
    this.empNo,
  });

  factory LoginDetailsDto.fromJson(Map<String, dynamic> json) {
    return LoginDetailsDto(
      userId: json['userId'],
      userName: json['userName'],
      companyId: json['companyId'],
      roleCode: json['roleCode'],
      designation: json['designation'],
      fullName: json['fullName'],
      mobileNo: json['mobileNo'],
      division: json['division'],
      empNo: json['empNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'companyId': companyId,
      'roleCode': roleCode,
      'designation': designation,
      'fullName': fullName,
      'mobileNo': mobileNo,
      'division': division,
      'empNo': empNo,
    };
  }
}