import 'dart:convert';

CheckInResponse checkInResponseFromJson(String str) => CheckInResponse.fromJson(json.decode(str));

String checkInResponseToJson(CheckInResponse data) => json.encode(data.toJson());

class CheckInResponse {
  int? statusCode;
  String? message;
  Data? data;

  CheckInResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) => CheckInResponse(
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
  int? userId;
  dynamic addressId;
  String? checkIn;
  String? ipAddress;
  dynamic type;
  int? id;

  Data({
    this.userId,
    this.addressId,
    this.checkIn,
    this.ipAddress,
    this.type,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    addressId: json["address_id"],
    checkIn: json["check_in"],
    ipAddress: json["ip_address"],
    type: json["type"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "address_id": addressId,
    "check_in": checkIn,
    "ip_address": ipAddress,
    "type": type,
    "id": id,
  };
}
