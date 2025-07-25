import 'dart:convert';

LeaveTypeResponse leaveTypeResponseFromJson(String str) => LeaveTypeResponse.fromJson(json.decode(str));

String leaveTypeResponseToJson(LeaveTypeResponse data) => json.encode(data.toJson());

class LeaveTypeResponse {
  int statusCode;
  String message;
  List<LeaveTypeVO> data;

  LeaveTypeResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) => LeaveTypeResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: List<LeaveTypeVO>.from(json["data"].map((x) => LeaveTypeVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaveTypeVO {
  int id;
  String name;

  LeaveTypeVO({
    required this.id,
    required this.name,
  });

  factory LeaveTypeVO.fromJson(Map<String, dynamic> json) => LeaveTypeVO(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
