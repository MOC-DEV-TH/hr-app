// To parse this JSON data, do
//
//     final leaveSummaryResponse = leaveSummaryResponseFromJson(jsonString);

import 'dart:convert';

LeaveSummaryResponse leaveSummaryResponseFromJson(String str) => LeaveSummaryResponse.fromJson(json.decode(str));

String leaveSummaryResponseToJson(LeaveSummaryResponse data) => json.encode(data.toJson());

class LeaveSummaryResponse {
  int? statusCode;
  String? message;
  List<Datum>? data;

  LeaveSummaryResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory LeaveSummaryResponse.fromJson(Map<String, dynamic> json) => LeaveSummaryResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  int? total;
  int? available;

  Datum({
    this.id,
    this.name,
    this.total,
    this.available,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    total: json["total"],
    available: json["available"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "total": total,
    "available": available,
  };
}
