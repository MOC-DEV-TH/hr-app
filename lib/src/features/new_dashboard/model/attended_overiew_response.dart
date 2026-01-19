import 'dart:convert';

AttendanceOverviewResponse attendanceOverviewResponseFromJson(String str) => AttendanceOverviewResponse.fromJson(json.decode(str));

String attendanceOverviewResponseToJson(AttendanceOverviewResponse data) => json.encode(data.toJson());

class AttendanceOverviewResponse {
  int? statusCode;
  String? message;
  List<AttendedOverviewVO>? data;
  int? holidayCount;
  int? announcementCount;

  AttendanceOverviewResponse({
    this.statusCode,
    this.message,
    this.data,
    this.holidayCount,
    this.announcementCount
  });

  factory AttendanceOverviewResponse.fromJson(Map<String, dynamic> json) => AttendanceOverviewResponse(
    statusCode: json["status_code"],
    holidayCount: json["holidayCount"],
    announcementCount: json["announcementCount"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AttendedOverviewVO>.from(json["data"]!.map((x) => AttendedOverviewVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "holidayCount": holidayCount,
    "announcementCount": announcementCount,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AttendedOverviewVO {
  String? day;
  int? onTime;
  int? late;
  int? leave;

  AttendedOverviewVO({
    this.day,
    this.onTime,
    this.late,
    this.leave,
  });

  factory AttendedOverviewVO.fromJson(Map<String, dynamic> json) => AttendedOverviewVO(
    day: json["day"],
    onTime: json["onTime"],
    late: json["late"],
    leave: json["leave"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "onTime": onTime,
    "late": late,
    "leave": leave,
  };
}
