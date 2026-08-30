import 'dart:convert';

import '../../employee_wfh_requests/model/wfh_requests_response.dart';

ProfileWfhRequestsResponse wfhRequestsResponseFromJson(String str) => ProfileWfhRequestsResponse.fromJson(json.decode(str));

String wfhRequestsResponseToJson(ProfileWfhRequestsResponse data) => json.encode(data.toJson());

class ProfileWfhRequestsResponse {
  int? statusCode;
  String? message;
  Data? data;

  ProfileWfhRequestsResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory ProfileWfhRequestsResponse.fromJson(Map<String, dynamic> json) => ProfileWfhRequestsResponse(
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
  List<WfhRequestVO>? data;
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Data({
    this.data,
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? [] : List<WfhRequestVO>.from(json["data"]!.map((x) => WfhRequestVO.fromJson(x))),
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "last_page": lastPage,
  };
}

