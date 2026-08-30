import 'dart:convert';

LeaveStatusResponse leaveStatusResponseFromJson(String str) =>
    LeaveStatusResponse.fromJson(json.decode(str));

String leaveStatusResponseToJson(LeaveStatusResponse data) =>
    json.encode(data.toJson());

/// =======================
/// RESPONSE
/// =======================
class LeaveStatusResponse {
  int? statusCode;
  String? message;
  List<LeaveStatusVO>? data;

  LeaveStatusResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory LeaveStatusResponse.fromJson(Map<String, dynamic> json) =>
      LeaveStatusResponse(
        statusCode: json["status_code"],
        message: json["message"],
        data: (json["data"] as List?)
            ?.map((x) => LeaveStatusVO.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

/// =======================
/// LEAVE ITEM
/// =======================
class LeaveStatusVO {
  int? id;
  int? userId;
  DateTime? date;
  LeaveType? leaveType;
  String? message;
  dynamic approvedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  LeaveStatusVO({
    this.id,
    this.userId,
    this.date,
    this.leaveType,
    this.message,
    this.approvedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory LeaveStatusVO.fromJson(Map<String, dynamic> json) => LeaveStatusVO(
    id: json["id"],
    userId: json["user_id"] ?? json["user"]?["id"],
    date: _parseDate(json["date"]),
    leaveType:
    json["leave_type"] == null ? null : LeaveType.fromJson(json["leave_type"]),
    message: json["message"],
    approvedBy: json["approved_by"],
    status: json["status"],
    createdAt: _parseDate(json["created_at"]),
    updatedAt: _parseDate(json["updated_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "date": date?.toIso8601String(),
    "leave_type": leaveType?.toJson(),
    "message": message,
    "approved_by": approvedBy,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}

/// =======================
/// LEAVE TYPE
/// =======================
class LeaveType {
  int? id;
  String? name;

  LeaveType({this.id, this.name});

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

/// =======================
/// USER
/// =======================
class User {
  int? id;
  String? name;
  String? email;
  String? employeePosition;
  String? profilePhotoPath;

  User({
    this.id,
    this.name,
    this.email,
    this.employeePosition,
    this.profilePhotoPath
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    employeePosition: json["position"],
    profilePhotoPath: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "position": employeePosition,
    "profile_photo": profilePhotoPath,
  };
}

/// =======================
/// DATE PARSER (SAFE)
/// =======================
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;

  if (value is String) {
    return DateTime.tryParse(value);
  }

  if (value is int) {
    final isMs = value > 1000000000000;
    return DateTime.fromMillisecondsSinceEpoch(isMs ? value : value * 1000);
  }

  return null;
}
