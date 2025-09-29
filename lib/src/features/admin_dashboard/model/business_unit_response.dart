import 'dart:convert';

BusinessUnitResponse businessUnitResponseFromJson(String str) => BusinessUnitResponse.fromJson(json.decode(str));

String businessUnitResponseToJson(BusinessUnitResponse data) => json.encode(data.toJson());

class BusinessUnitResponse {
  int? statusCode;
  String? message;
  List<BusinessUnitVO>? data;

  BusinessUnitResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory BusinessUnitResponse.fromJson(Map<String, dynamic> json) => BusinessUnitResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BusinessUnitVO>.from(json["data"]!.map((x) => BusinessUnitVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BusinessUnitVO {
  int? id;
  String? name;

  BusinessUnitVO({
    this.id,
    this.name,
  });

  factory BusinessUnitVO.fromJson(Map<String, dynamic> json) => BusinessUnitVO(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
