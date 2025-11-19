import 'dart:convert';

EmployeeDropdownResponse employeeDropdownResponseFromJson(String str) => EmployeeDropdownResponse.fromJson(json.decode(str));

String employeeDropdownResponseToJson(EmployeeDropdownResponse data) => json.encode(data.toJson());

class EmployeeDropdownResponse {
  int? statusCode;
  String? message;
  EmployeeDropdownVO? data;

  EmployeeDropdownResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeeDropdownResponse.fromJson(Map<String, dynamic> json) => EmployeeDropdownResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : EmployeeDropdownVO.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class EmployeeDropdownVO {
  List<IDNameVO>? countries;
  List<IDNameVO>? businessUnits;
  List<IDNameVO>? departments;
  List<IDNameVO>? positions;
  List<IDNameVO>? roles;
  List<IDNameVO>? employeeTypes;

  EmployeeDropdownVO({
    this.countries,
    this.businessUnits,
    this.departments,
    this.positions,
    this.roles,
    this.employeeTypes,
  });

  factory EmployeeDropdownVO.fromJson(Map<String, dynamic> json) => EmployeeDropdownVO(
    countries: json["countries"] == null ? [] : List<IDNameVO>.from(json["countries"]!.map((x) => IDNameVO.fromJson(x))),
    businessUnits: json["business_units"] == null ? [] : List<IDNameVO>.from(json["business_units"]!.map((x) => IDNameVO.fromJson(x))),
    departments: json["departments"] == null ? [] : List<IDNameVO>.from(json["departments"]!.map((x) => IDNameVO.fromJson(x))),
    positions: json["positions"] == null ? [] : List<IDNameVO>.from(json["positions"]!.map((x) => IDNameVO.fromJson(x))),
    roles: json["roles"] == null ? [] : List<IDNameVO>.from(json["roles"]!.map((x) => IDNameVO.fromJson(x))),
    employeeTypes: json["employee_types"] == null ? [] : List<IDNameVO>.from(json["employee_types"]!.map((x) => IDNameVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": countries == null ? [] : List<dynamic>.from(countries!.map((x) => x.toJson())),
    "business_units": businessUnits == null ? [] : List<dynamic>.from(businessUnits!.map((x) => x.toJson())),
    "departments": departments == null ? [] : List<dynamic>.from(departments!.map((x) => x.toJson())),
    "positions": positions == null ? [] : List<dynamic>.from(positions!.map((x) => x.toJson())),
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
    "employee_types": employeeTypes == null ? [] : List<dynamic>.from(employeeTypes!.map((x) => x.toJson())),
  };
}

class IDNameVO {
  int? id;
  String? name;

  IDNameVO({
    this.id,
    this.name,
  });

  factory IDNameVO.fromJson(Map<String, dynamic> json) => IDNameVO(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
