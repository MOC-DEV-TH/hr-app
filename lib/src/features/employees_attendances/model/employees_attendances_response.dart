import 'dart:convert';

import 'package:hr_app/src/features/admin_dashboard/model/admin_dasbhoard_response.dart';

EmployeesAttendancesResponse employeesAttendancesResponseFromJson(String str) => EmployeesAttendancesResponse.fromJson(json.decode(str));

String employeesAttendancesResponseToJson(EmployeesAttendancesResponse data) => json.encode(data.toJson());

class EmployeesAttendancesResponse {
  int? statusCode;
  String? message;
  Data? data;

  EmployeesAttendancesResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeesAttendancesResponse.fromJson(Map<String, dynamic> json) => EmployeesAttendancesResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<EmployeeAttendanceDataVO>? data;
  int? total;
  int? perPage;
  int? current;
  int? lastPage;

  Data({
    this.data,
    this.total,
    this.perPage,
    this.current,
    this.lastPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? [] : List<EmployeeAttendanceDataVO>.from(json["data"]!.map((x) => EmployeeAttendanceDataVO.fromJson(x))),
    total: json["total"],
    perPage: json["per_page"],
    current: json["current"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "per_page": perPage,
    "current": current,
    "last_page": lastPage,
  };
}


