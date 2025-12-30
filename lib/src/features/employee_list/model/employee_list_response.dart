import 'dart:convert';

EmployeeListResponse employeeListResponseFromJson(String str) => EmployeeListResponse.fromJson(json.decode(str));

String employeeListResponseToJson(EmployeeListResponse data) => json.encode(data.toJson());

class EmployeeListResponse {
  int? statusCode;
  String? message;
  Data? data;

  EmployeeListResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) => EmployeeListResponse(
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
  List<EmployeeVO>? data;
  int? total;
  int? perPage;
  int? current;
  int? lastPage;

  Data({
    this.data,
    this.total,
    this.perPage,
    this.current,
    this.lastPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? [] : List<EmployeeVO>.from(json["data"]!.map((x) => EmployeeVO.fromJson(x))),
    total: json["total"],
    perPage: json["per_page"],
    current: json["current"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "per_page": perPage,
    "current": current,
    "last_page": lastPage,
  };
}

class EmployeeVO {
  int? id;
  String? name;
  int? positionId;
  String? position;

  EmployeeVO({
    this.id,
    this.name,
    this.positionId,
    this.position,
  });

  factory EmployeeVO.fromJson(Map<String, dynamic> json) => EmployeeVO(
    id: json["id"],
    name: json["name"],
    positionId: json["position_id"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "position_id": positionId,
    "position": position,
  };
}

class Position {
  int? id;
  String? name;

  Position({
    this.id,
    this.name,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
