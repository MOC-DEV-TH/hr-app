import 'dart:convert';

EmployeeDashboardResponse employeeDashboardResponseFromJson(String str) => EmployeeDashboardResponse.fromJson(json.decode(str));

String employeeDashboardResponseToJson(EmployeeDashboardResponse data) => json.encode(data.toJson());

class EmployeeDashboardResponse {
  int? statusCode;
  String? message;
  Data? data;

  EmployeeDashboardResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeeDashboardResponse.fromJson(Map<String, dynamic> json) => EmployeeDashboardResponse(
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
  int? month;
  String? monthName;
  int? year;
  AttendanceOverview? attendanceOverview;
  LeaveSummary? leaveSummary;

  Data({
    this.month,
    this.monthName,
    this.year,
    this.attendanceOverview,
    this.leaveSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    month: json["month"],
    monthName: json["month_name"],
    year: json["year"],
    attendanceOverview: json["attendance_overview"] == null ? null : AttendanceOverview.fromJson(json["attendance_overview"]),
    leaveSummary: json["leave_summary"] == null ? null : LeaveSummary.fromJson(json["leave_summary"]),
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "month_name": monthName,
    "year": year,
    "attendance_overview": attendanceOverview?.toJson(),
    "leave_summary": leaveSummary?.toJson(),
  };
}

class AttendanceOverview {
  int? onTime;
  int? late;
  int? notLogin;

  AttendanceOverview({
    this.onTime,
    this.late,
    this.notLogin,
  });

  factory AttendanceOverview.fromJson(Map<String, dynamic> json) => AttendanceOverview(
    onTime: json["on_time"],
    late: json["late"],
    notLogin: json["not_login"],
  );

  Map<String, dynamic> toJson() => {
    "on_time": onTime,
    "late": late,
    "not_login": notLogin,
  };
}

class LeaveSummary {
  int? totalRequests;
  int? approved;
  int? pending;
  int? rejected;

  LeaveSummary({
    this.totalRequests,
    this.approved,
    this.pending,
    this.rejected,
  });

  factory LeaveSummary.fromJson(Map<String, dynamic> json) => LeaveSummary(
    totalRequests: json["total_requests"],
    approved: json["approved"],
    pending: json["pending"],
    rejected: json["rejected"],
  );

  Map<String, dynamic> toJson() => {
    "total_requests": totalRequests,
    "approved": approved,
    "pending": pending,
    "rejected": rejected,
  };
}
