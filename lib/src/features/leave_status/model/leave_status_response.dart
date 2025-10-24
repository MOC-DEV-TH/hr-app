import 'dart:convert';

import '../../admin_dashboard/model/admin_dasbhoard_response.dart';

LeaveStatusResponse leaveStatusResponseFromJson(String str) => LeaveStatusResponse.fromJson(json.decode(str));

String leaveStatusResponseToJson(LeaveStatusResponse data) => json.encode(data.toJson());

class LeaveStatusResponse {
  int statusCode;
  String message;
  List<LeaveStatusVO> data;

  LeaveStatusResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LeaveStatusResponse.fromJson(Map<String, dynamic> json) => LeaveStatusResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: List<LeaveStatusVO>.from(json["data"].map((x) => LeaveStatusVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaveStatusVO {
  int id;
  int userId;
  DateTime date;
  LeaveType leaveType;
  String message;
  dynamic approvedBy;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  User? user;

  LeaveStatusVO({
    required this.id,
    required this.userId,
    required this.date,
    required this.leaveType,
    required this.message,
    required this.approvedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user
  });

  factory LeaveStatusVO.fromJson(Map<String, dynamic> json) => LeaveStatusVO(
    id: json["id"],
    userId: json["user_id"],
    date: DateTime.parse(json["date"]),
    leaveType: LeaveType.fromJson(json["leave_type"]),
    message: json["message"],
    approvedBy: json["approved_by"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "leave_type": leaveType.toJson(),
    "message": message,
    "approved_by": approvedBy,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user?.toJson(),
  };
}

class LeaveType {
  int id;
  String name;

  LeaveType({
    required this.id,
    required this.name,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  EmployeePosition? employeePosition;

  User({
    this.id,
    this.name,
    this.email,
    this.employeePosition
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    employeePosition:
    json["position"] == null
        ? null
        : EmployeePosition.fromJson(json["position"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "position": employeePosition?.toJson(),
  };
}

