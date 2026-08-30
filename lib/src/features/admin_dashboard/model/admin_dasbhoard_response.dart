import 'dart:convert';

AdminDashboardResponse adminDashboardResponseFromJson(String str) =>
    AdminDashboardResponse.fromJson(json.decode(str));

String adminDashboardResponseToJson(AdminDashboardResponse data) =>
    json.encode(data.toJson());

class AdminDashboardResponse {
  int? statusCode;
  String? message;
  Data? data;

  AdminDashboardResponse({this.statusCode, this.message, this.data});

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) =>
      AdminDashboardResponse(
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
  List<BusinessUnit>? businessUnits;
  int? selectedBuId;
  int? leaveCount;
  int? wfhCount;
  List<EmployeeAttendanceDataVO>? attendanceData;

  Data({this.businessUnits, this.selectedBuId, this.attendanceData,this.leaveCount,this.wfhCount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    businessUnits:
        json["businessUnits"] == null
            ? []
            : List<BusinessUnit>.from(
              json["businessUnits"]!.map((x) => BusinessUnit.fromJson(x)),
            ),
    selectedBuId: json["selected_bu_id"],
    leaveCount: json["leaveCount"],
    wfhCount: json["wfhCount"],
    attendanceData:
        json["attendanceData"] == null
            ? []
            : List<EmployeeAttendanceDataVO>.from(
              json["attendanceData"]!.map(
                (x) => EmployeeAttendanceDataVO.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "businessUnits":
        businessUnits == null
            ? []
            : List<dynamic>.from(businessUnits!.map((x) => x.toJson())),
    "selected_bu_id": selectedBuId,
    "leaveCount": leaveCount,
    "wfhCount": wfhCount,
    "attendanceData":
        attendanceData == null
            ? []
            : List<dynamic>.from(attendanceData!.map((x) => x.toJson())),
  };
}

class EmployeeAttendanceDataVO {
  int? id;
  String? name;
  int? bussinessUnitId;
  String? profilePhotoPath;
  EmployeePosition? employeePosition;
  AttendanceForDateVO? attendanceForDate;

  EmployeeAttendanceDataVO({
    this.id,
    this.name,
    this.bussinessUnitId,
    this.employeePosition,
    this.attendanceForDate,
    this.profilePhotoPath
  });

  factory EmployeeAttendanceDataVO.fromJson(Map<String, dynamic> json) =>
      EmployeeAttendanceDataVO(
        id: json["id"],
        name: json["name"],
        bussinessUnitId: json["bussiness_unit_id"],
        profilePhotoPath: json["profile_photo"],
        employeePosition:
            json["position"] == null
                ? null
                : EmployeePosition.fromJson(json["position"]),
        attendanceForDate:
            json["attendance_for_date"] == null
                ? null
                : AttendanceForDateVO.fromJson(json["attendance_for_date"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "bussiness_unit_id": bussinessUnitId,
    "profile_photo": profilePhotoPath,
    "position": employeePosition?.toJson(),
    "attendance_for_date": attendanceForDate?.toJson(),
  };
}

class AttendanceForDateVO {
  int? id;
  int? userId;
  DateTime? checkIn;
  DateTime? checkOut;
  DateTime? createdAt;

  AttendanceForDateVO({
    this.id,
    this.userId,
    this.checkIn,
    this.checkOut,
    this.createdAt,
  });

  factory AttendanceForDateVO.fromJson(
    Map<String, dynamic> json,
  ) => AttendanceForDateVO(
    id: json["id"],
    userId: json["user_id"],
    checkIn: json["check_in"] == null ? null : DateTime.parse(json["check_in"]),
    checkOut:
        json["check_out"] == null ? null : DateTime.parse(json["check_out"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "check_in": checkIn?.toIso8601String(),
    "check_out": checkOut?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class BusinessUnit {
  int? id;
  String? name;

  BusinessUnit({this.id, this.name});

  factory BusinessUnit.fromJson(Map<String, dynamic> json) =>
      BusinessUnit(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class EmployeePosition {
  int? id;
  String? name;

  EmployeePosition({this.id, this.name});

  factory EmployeePosition.fromJson(Map<String, dynamic> json) =>
      EmployeePosition(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
