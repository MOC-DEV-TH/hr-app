import 'dart:convert';

import 'package:hr_app/src/features/announcement/model/announcement_response.dart';

AnnouncementDetailResponse announcementDetailResponseFromJson(String str) =>
    AnnouncementDetailResponse.fromJson(json.decode(str));

String announcementDetailResponseToJson(AnnouncementDetailResponse data) =>
    json.encode(data.toJson());

class AnnouncementDetailResponse {
  bool? status;
  Data? data;

  AnnouncementDetailResponse({this.status, this.data});

  factory AnnouncementDetailResponse.fromJson(Map<String, dynamic> json) =>
      AnnouncementDetailResponse(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  AnnouncementVO? announcement;
  Map<String, String>? businessUnits;
  bool? isGot;

  Data({this.announcement, this.businessUnits, this.isGot});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    announcement:
        json["announcement"] == null
            ? null
            : AnnouncementVO.fromJson(json["announcement"]),
    businessUnits: Map.from(
      json["business_units"]!,
    ).map((k, v) => MapEntry<String, String>(k, v)),
    isGot: json["is_got"],
  );

  Map<String, dynamic> toJson() => {
    "announcement": announcement?.toJson(),
    "business_units": Map.from(
      businessUnits!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "is_got": isGot,
  };
}
