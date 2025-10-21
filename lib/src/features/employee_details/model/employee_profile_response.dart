// To parse this JSON data, do
//
//     final employeeProfileResponse = employeeProfileResponseFromJson(jsonString);

import 'dart:convert';

EmployeeProfileResponse employeeProfileResponseFromJson(String str) => EmployeeProfileResponse.fromJson(json.decode(str));

String employeeProfileResponseToJson(EmployeeProfileResponse data) => json.encode(data.toJson());

class EmployeeProfileResponse {
  int? statusCode;
  String? message;
  ProfileVO? data;

  EmployeeProfileResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeeProfileResponse.fromJson(Map<String, dynamic> json) => EmployeeProfileResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileVO.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileVO {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phone;
  int? positionId;
  int? employeeTypeId;
  int? allowRemoteLogin;
  List<int>? departmentId;
  int? role;
  int? bussinessUnitId;
  int? countryId;
  int? isDepartmentHead;
  bool? active;
  String? departments;
  BussinessUnit? bussinessUnit;
  EmployeeType? employeeType;
  Position? position;
  Country? country;

  ProfileVO({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.positionId,
    this.employeeTypeId,
    this.allowRemoteLogin,
    this.departmentId,
    this.role,
    this.bussinessUnitId,
    this.countryId,
    this.isDepartmentHead,
    this.active,
    this.departments,
    this.bussinessUnit,
    this.employeeType,
    this.position,
    this.country,
  });

  factory ProfileVO.fromJson(Map<String, dynamic> json) => ProfileVO(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    positionId: json["position_id"],
    employeeTypeId: json["employee_type_id"],
    allowRemoteLogin: json["allow_remote_login"],
    departmentId: json["department_id"] == null ? [] : List<int>.from(json["department_id"]!.map((x) => x)),
    role: json["role"],
    bussinessUnitId: json["bussiness_unit_id"],
    countryId: json["country_id"],
    isDepartmentHead: json["is_department_head"],
    active: json["active"],
    departments: json["departments"],
    bussinessUnit: json["bussiness_unit"] == null ? null : BussinessUnit.fromJson(json["bussiness_unit"]),
    employeeType: json["employee_type"] == null ? null : EmployeeType.fromJson(json["employee_type"]),
    position: json["position"] == null ? null : Position.fromJson(json["position"]),
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "position_id": positionId,
    "employee_type_id": employeeTypeId,
    "allow_remote_login": allowRemoteLogin,
    "department_id": departmentId == null ? [] : List<dynamic>.from(departmentId!.map((x) => x)),
    "role": role,
    "bussiness_unit_id": bussinessUnitId,
    "country_id": countryId,
    "is_department_head": isDepartmentHead,
    "active": active,
    "departments": departments,
    "bussiness_unit": bussinessUnit?.toJson(),
    "employee_type": employeeType?.toJson(),
    "position": position?.toJson(),
    "country": country?.toJson(),
  };
}

class BussinessUnit {
  int? id;
  int? countryId;
  String? name;
  String? description;
  String? lat;
  String? long;

  BussinessUnit({
    this.id,
    this.countryId,
    this.name,
    this.description,
    this.lat,
    this.long,
  });

  factory BussinessUnit.fromJson(Map<String, dynamic> json) => BussinessUnit(
    id: json["id"],
    countryId: json["country_id"],
    name: json["name"],
    description: json["description"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "name": name,
    "description": description,
    "lat": lat,
    "long": long,
  };
}

class Country {
  int? id;
  String? name;
  String? description;

  Country({
    this.id,
    this.name,
    this.description,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class EmployeeType {
  int? id;
  String? name;
  List<int>? leaveTypeIds;

  EmployeeType({
    this.id,
    this.name,
    this.leaveTypeIds,
  });

  factory EmployeeType.fromJson(Map<String, dynamic> json) => EmployeeType(
    id: json["id"],
    name: json["name"],
    leaveTypeIds: json["leave_type_ids"] == null ? [] : List<int>.from(json["leave_type_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "leave_type_ids": leaveTypeIds == null ? [] : List<dynamic>.from(leaveTypeIds!.map((x) => x)),
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
