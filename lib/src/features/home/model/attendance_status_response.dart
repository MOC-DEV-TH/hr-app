import 'dart:convert';

AttendanceStatusResponse attendanceStatusResponseFromJson(String str) => AttendanceStatusResponse.fromJson(json.decode(str));

String attendanceStatusResponseToJson(AttendanceStatusResponse data) => json.encode(data.toJson());

class AttendanceStatusResponse {
  int? statusCode;
  String? message;
  Data? data;

  AttendanceStatusResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendanceStatusResponse.fromJson(Map<String, dynamic> json) => AttendanceStatusResponse(
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
  int? userId;
  DateTime? date;
  int? attendanceId;
  bool? isCheckedIn;
  bool? isCheckedOut;
  bool? isComplete;
  String? status;
  String? checkIn;
  dynamic checkOut;

  Data({
    this.userId,
    this.date,
    this.attendanceId,
    this.isCheckedIn,
    this.isCheckedOut,
    this.isComplete,
    this.status,
    this.checkIn,
    this.checkOut,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    attendanceId: json["attendance_id"],
    isCheckedIn: json["is_checked_in"],
    isCheckedOut: json["is_checked_out"],
    isComplete: json["is_complete"],
    status: json["status"],
    checkIn: json["check_in"],
    checkOut: json["check_out"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "attendance_id": attendanceId,
    "is_checked_in": isCheckedIn,
    "is_checked_out": isCheckedOut,
    "is_complete": isComplete,
    "status": status,
    "check_in": checkIn,
    "check_out": checkOut,
  };
}