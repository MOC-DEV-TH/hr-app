import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int? statusCode;
  String? message;
  String? role;
  UserData? data;

  LoginResponse({this.statusCode, this.message, this.role, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    statusCode: json["status_code"] as int?,
    message: json["message"] as String?,
    role: json["role"] as String?,
    data:
        json["data"] != null
            ? UserData.fromJson(json["data"] as Map<String, dynamic>)
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (statusCode != null) "status_code": statusCode,
    if (message != null) "message": message,
    if (role != null) "role": role,
    if (data != null) "data": data!.toJson(),
  };
}

class UserData {
  String? accessToken;
  String? tokenType;
  UserVO? user;

  UserData({this.accessToken, this.tokenType, this.user});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    accessToken: json["access_token"] as String?,
    tokenType: json["token_type"] as String?,
    user:
        json["user"] != null
            ? UserVO.fromJson(json["user"] as Map<String, dynamic>)
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (accessToken != null) "access_token": accessToken,
    if (tokenType != null) "token_type": tokenType,
    if (user != null) "user": user!.toJson(),
  };
}


class UserVO {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phone;
  int? positionId;
  dynamic departmentId;
  int? role;
  dynamic bussinessUnitId;
  int? employeeTypeId;
  int? allowRemoteLogin;
  dynamic countryId;
  int? isDepartmentHead;
  bool? active;
  int? allowWfhRequest;
  String? checkInTimezone;
  dynamic twoFactorConfirmedAt;
  dynamic currentTeamId;
  dynamic profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrgStructure>? orgStructure;
  List<Address>? addresses;
  Position? position;
  EmployeeType? employeeType;

  UserVO({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.positionId,
    this.departmentId,
    this.role,
    this.bussinessUnitId,
    this.employeeTypeId,
    this.allowRemoteLogin,
    this.countryId,
    this.isDepartmentHead,
    this.active,
    this.allowWfhRequest,
    this.checkInTimezone,
    this.twoFactorConfirmedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
    this.orgStructure,
    this.addresses,
    this.position,
    this.employeeType,
  });

  factory UserVO.fromJson(Map<String, dynamic> json) => UserVO(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    positionId: json["position_id"],
    departmentId: json["department_id"],
    role: json["role"],
    bussinessUnitId: json["bussiness_unit_id"],
    employeeTypeId: json["employee_type_id"],
    allowRemoteLogin: json["allow_remote_login"],
    countryId: json["country_id"],
    isDepartmentHead: json["is_department_head"],
    active: json["active"],
    allowWfhRequest: json["allow_wfh_request"],
    checkInTimezone: json["check_in_timezone"],
    twoFactorConfirmedAt: json["two_factor_confirmed_at"],
    currentTeamId: json["current_team_id"],
    profilePhotoPath: json["profile_photo_path"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    orgStructure: json["org_structure"] == null ? [] : List<OrgStructure>.from(json["org_structure"]!.map((x) => OrgStructure.fromJson(x))),
    addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
    position: json["position"] == null ? null : Position.fromJson(json["position"]),
    employeeType: json["employee_type"] == null ? null : EmployeeType.fromJson(json["employee_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "position_id": positionId,
    "department_id": departmentId,
    "role": role,
    "bussiness_unit_id": bussinessUnitId,
    "employee_type_id": employeeTypeId,
    "allow_remote_login": allowRemoteLogin,
    "country_id": countryId,
    "is_department_head": isDepartmentHead,
    "active": active,
    "allow_wfh_request": allowWfhRequest,
    "check_in_timezone": checkInTimezone,
    "two_factor_confirmed_at": twoFactorConfirmedAt,
    "current_team_id": currentTeamId,
    "profile_photo_path": profilePhotoPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "org_structure": orgStructure == null ? [] : List<dynamic>.from(orgStructure!.map((x) => x.toJson())),
    "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "position": position?.toJson(),
    "employee_type": employeeType?.toJson(),
  };
}

class Address {
  int? id;
  int? userId;
  String? addressName;
  String? fullAddress;
  String? lat;
  String? long;

  Address({
    this.id,
    this.userId,
    this.addressName,
    this.fullAddress,
    this.lat,
    this.long,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    userId: json["user_id"],
    addressName: json["address_name"],
    fullAddress: json["full_address"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "address_name": addressName,
    "full_address": fullAddress,
    "lat": lat,
    "long": long,
  };
}

class EmployeeType {
  int? id;
  String? name;
  List<dynamic>? leaveTypeIds;

  EmployeeType({
    this.id,
    this.name,
    this.leaveTypeIds,
  });

  factory EmployeeType.fromJson(Map<String, dynamic> json) => EmployeeType(
    id: json["id"],
    name: json["name"],
    leaveTypeIds: json["leave_type_ids"] == null ? [] : List<dynamic>.from(json["leave_type_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "leave_type_ids": leaveTypeIds == null ? [] : List<dynamic>.from(leaveTypeIds!.map((x) => x)),
  };
}

class OrgStructure {
  int? id;
  int? userId;
  int? countryId;
  int? bussinessUnitId;
  List<int>? departmentId;

  OrgStructure({
    this.id,
    this.userId,
    this.countryId,
    this.bussinessUnitId,
    this.departmentId,
  });

  factory OrgStructure.fromJson(Map<String, dynamic> json) => OrgStructure(
    id: json["id"],
    userId: json["user_id"],
    countryId: json["country_id"],
    bussinessUnitId: json["bussiness_unit_id"],
    departmentId: json["department_id"] == null ? [] : List<int>.from(json["department_id"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "country_id": countryId,
    "bussiness_unit_id": bussinessUnitId,
    "department_id": departmentId == null ? [] : List<dynamic>.from(departmentId!.map((x) => x)),
  };
}

class Position {
  int? id;
  String? name;

  Position({
    this.id,
    this.name,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

