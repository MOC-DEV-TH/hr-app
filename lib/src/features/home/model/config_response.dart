import 'dart:convert';

ConfigResponse? attendanceConfigResponseFromJson(String str) =>
    str.isNotEmpty ? ConfigResponse.fromJson(json.decode(str)) : null;

String attendanceConfigResponseToJson(ConfigResponse? data) =>
    data != null ? json.encode(data.toJson()) : '';

class ConfigResponse {
  int? statusCode;
  String? message;
  ConfigData? data;

  ConfigResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => ConfigResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] != null ? ConfigData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class ConfigData {
  int? allowDistance;
  int? allowLogoutDistance;
  BusinessUnit? businessUnit;

  ConfigData({
    this.allowDistance,
    this.allowLogoutDistance,
    this.businessUnit,
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) => ConfigData(
    allowDistance: json["allow_distance"],
    allowLogoutDistance: json["allow_log_out_distance"],
    businessUnit: json["bussiness_unit"] != null
        ? BusinessUnit.fromJson(json["bussiness_unit"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "allow_distance": allowDistance,
    "allow_log_out_distance": allowLogoutDistance,
    "bussiness_unit": businessUnit?.toJson(),
  };
}

class BusinessUnit {
  String? lat;
  String? long;

  BusinessUnit({
    this.lat,
    this.long,
  });

  factory BusinessUnit.fromJson(Map<String, dynamic> json) => BusinessUnit(
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "long": long,
  };
}
