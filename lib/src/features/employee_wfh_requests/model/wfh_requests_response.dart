import 'dart:convert';

WfhRequestsResponse wfhRequestsResponseFromJson(String str) => WfhRequestsResponse.fromJson(json.decode(str));

String wfhRequestsResponseToJson(WfhRequestsResponse data) => json.encode(data.toJson());

class WfhRequestsResponse {
  bool? status;
  List<WfhRequestVO>? data;

  WfhRequestsResponse({
    this.status,
    this.data,
  });

  factory WfhRequestsResponse.fromJson(Map<String, dynamic> json) => WfhRequestsResponse(
    status: json["status"],
    data: json["data"] == null ? [] : List<WfhRequestVO>.from(json["data"]!.map((x) => WfhRequestVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WfhRequestVO {
  int? id;
  int? userId;
  DateTime? wfhDate;
  String? name;
  String? message;
  String? affectOperation;
  String? status;
  String? profilePhotoPath;
  String? position;
  DateTime? createdAt;
  DateTime? updatedAt;

  WfhRequestVO({
    this.id,
    this.userId,
    this.wfhDate,
    this.name,
    this.message,
    this.affectOperation,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.profilePhotoPath
  });

  factory WfhRequestVO.fromJson(Map<String, dynamic> json) => WfhRequestVO(
    id: json["id"],
    userId: json["user_id"],
    wfhDate: json["wfh_date"] == null ? null : DateTime.parse(json["wfh_date"]),
    name: json["name"],
    position: json["position"],
    profilePhotoPath: json["profile_photo"],
    message: json["message"],
    affectOperation: json["affect_operation"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "wfh_date": "${wfhDate!.year.toString().padLeft(4, '0')}-${wfhDate!.month.toString().padLeft(2, '0')}-${wfhDate!.day.toString().padLeft(2, '0')}",
    "name": name,
    "message": message,
    "profile_photo": profilePhotoPath,
    "affect_operation": affectOperation,
    "position" : position,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
