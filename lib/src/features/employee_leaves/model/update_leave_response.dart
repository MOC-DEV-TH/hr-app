import 'dart:convert';

UpdateLeaveResponse leaveUpdateResponseFromJson(String str) => UpdateLeaveResponse.fromJson(json.decode(str));

String leaveUpdateResponseToJson(UpdateLeaveResponse data) => json.encode(data.toJson());

class UpdateLeaveResponse {
  int? statusCode;
  String? message;
  UpdateLeaveResponseVO? data;

  UpdateLeaveResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory UpdateLeaveResponse.fromJson(Map<String, dynamic> json) => UpdateLeaveResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? null : UpdateLeaveResponseVO.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class UpdateLeaveResponseVO {
  int? id;
  int? userId;
  DateTime? date;
  LeaveType? leaveType;
  String? message;
  int? halfDay;
  dynamic period;
  int? approvedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  UpdateLeaveResponseVO({
    this.id,
    this.userId,
    this.date,
    this.leaveType,
    this.message,
    this.halfDay,
    this.period,
    this.approvedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UpdateLeaveResponseVO.fromJson(Map<String, dynamic> json) => UpdateLeaveResponseVO(
    id: json["id"],
    userId: json["user_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    leaveType: json["leave_type"] == null ? null : LeaveType.fromJson(json["leave_type"]),
    message: json["message"],
    halfDay: json["half_day"],
    period: json["period"],
    approvedBy: json["approved_by"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "leave_type": leaveType?.toJson(),
    "message": message,
    "half_day": halfDay,
    "period": period,
    "approved_by": approvedBy,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class LeaveType {
  int? id;
  String? name;

  LeaveType({
    this.id,
    this.name,
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