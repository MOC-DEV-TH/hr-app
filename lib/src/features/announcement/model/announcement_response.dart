import 'dart:convert';

AnnouncementResponse announcementResponseFromJson(String str) => AnnouncementResponse.fromJson(json.decode(str));

String announcementResponseToJson(AnnouncementResponse data) => json.encode(data.toJson());

class AnnouncementResponse {
  int? statusCode;
  String? message;
  List<AnnouncementVO>? data;

  AnnouncementResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) => AnnouncementResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AnnouncementVO>.from(json["data"]!.map((x) => AnnouncementVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AnnouncementVO {
  int? id;
  String? title;
  int? announcementTypeId;
  String? description;
  List<int>? businessUnits;
  DateTime? createdAt;

  AnnouncementVO({
    this.id,
    this.title,
    this.announcementTypeId,
    this.description,
    this.businessUnits,
    this.createdAt
  });

  factory AnnouncementVO.fromJson(Map<String, dynamic> json) => AnnouncementVO(
    id: json["id"],
    title: json["title"],
    announcementTypeId: json["announcement_type_id"],
    description: json["description"],
    businessUnits: json["business_units"] == null ? [] : List<int>.from(json["business_units"]!.map((x) => x)),
    createdAt:
    json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "announcement_type_id": announcementTypeId,
    "description": description,
    "business_units": businessUnits == null ? [] : List<dynamic>.from(businessUnits!.map((x) => x)),
    "created_at": createdAt?.toIso8601String(),
  };
}
