import 'dart:convert';

TotalEmployeeResponse totalEmployeeResponseFromJson(String str) => TotalEmployeeResponse.fromJson(json.decode(str));

String totalEmployeeResponseToJson(TotalEmployeeResponse data) => json.encode(data.toJson());

class TotalEmployeeResponse {
  int? status;
  String? message;
  List<EmployeeSegment>? data;

  TotalEmployeeResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TotalEmployeeResponse.fromJson(Map<String, dynamic> json) => TotalEmployeeResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<EmployeeSegment>.from(json["data"]!.map((x) => EmployeeSegment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class EmployeeSegment {
  String? label;
  int? value;
  String? color;

  EmployeeSegment({
    this.label,
    this.value,
    this.color,
  });

  factory EmployeeSegment.fromJson(Map<String, dynamic> json) => EmployeeSegment(
    label: json["label"],
    value: json["value"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
    "color": color,
  };

  String get safeLabel => label ?? '-';
  int get safeValue => value ?? 0;
}