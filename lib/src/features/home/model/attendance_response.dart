import 'dart:convert';

AttendanceResponse attendanceResponseFromJson(String str) => AttendanceResponse.fromJson(json.decode(str));

String attendanceResponseToJson(AttendanceResponse data) => json.encode(data.toJson());

class AttendanceResponse {
  int statusCode;
  String message;
  List<AttendanceDataVO> data;

  AttendanceResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) => AttendanceResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: List<AttendanceDataVO>.from(json["data"].map((x) => AttendanceDataVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AttendanceDataVO {
  DateTime? date;
  List<Attendance> attendances;

  AttendanceDataVO({
    required this.date,
    required this.attendances,
  });

  factory AttendanceDataVO.fromJson(Map<String, dynamic> json) => AttendanceDataVO(
    date: DateTime.parse(json["date"]),
    attendances: List<Attendance>.from(json["attendances"].map((x) => Attendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "attendances": List<dynamic>.from(attendances.map((x) => x.toJson())),
  };
}

class Attendance {
  int? userId;
  String? checkIn;
  String? checkOut;

  Attendance({
     this.userId,
     this.checkIn,
     this.checkOut,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    userId: json["user_id"],
    checkIn: json["check_in"],
    checkOut: json["check_out"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "check_in": checkIn,
    "check_out": checkOut,
  };
}
