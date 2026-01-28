import 'dart:convert';

UserAddressResponse userAddressResponseFromJson(String str) => UserAddressResponse.fromJson(json.decode(str));

String userAddressResponseToJson(UserAddressResponse data) => json.encode(data.toJson());

class UserAddressResponse {
  int? statusCode;
  String? message;
  List<AddressVO>? data;

  UserAddressResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory UserAddressResponse.fromJson(Map<String, dynamic> json) => UserAddressResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AddressVO>.from(json["data"]!.map((x) => AddressVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AddressVO {
  int? id;
  int? userId;
  String? addressName;
  String? fullAddress;
  String? lat;
  String? long;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressVO({
    this.id,
    this.userId,
    this.addressName,
    this.fullAddress,
    this.lat,
    this.long,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressVO.fromJson(Map<String, dynamic> json) => AddressVO(
    id: json["id"],
    userId: json["user_id"],
    addressName: json["address_name"],
    fullAddress: json["full_address"],
    lat: json["lat"],
    long: json["long"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "address_name": addressName,
    "full_address": fullAddress,
    "lat": lat,
    "long": long,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
