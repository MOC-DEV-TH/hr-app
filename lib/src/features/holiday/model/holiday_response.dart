import 'dart:convert';

HolidayResponse holidayResponseFromJson(String str) => HolidayResponse.fromJson(json.decode(str));

String holidayResponseToJson(HolidayResponse data) => json.encode(data.toJson());

class HolidayResponse {
  int? statusCode;
  String? message;
  List<HolidayResponseData>? data;

  HolidayResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory HolidayResponse.fromJson(Map<String, dynamic> json) => HolidayResponse(
    statusCode: json["status_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<HolidayResponseData>.from(json["data"]!.map((x) => HolidayResponseData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HolidayResponseData {
  String? month;
  List<HolidayVO>? holidays;

  HolidayResponseData({
    this.month,
    this.holidays,
  });

  factory HolidayResponseData.fromJson(Map<String, dynamic> json) => HolidayResponseData(
    month: json["month"],
    holidays: json["holidays"] == null ? [] : List<HolidayVO>.from(json["holidays"]!.map((x) => HolidayVO.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "holidays": holidays == null ? [] : List<dynamic>.from(holidays!.map((x) => x.toJson())),
  };
}

class HolidayVO {
  String? title;
  String? date;
  DateTime? isoDate;

  HolidayVO({
    this.title,
    this.date,
    this.isoDate,
  });

  factory HolidayVO.fromJson(Map<String, dynamic> json) => HolidayVO(
    title: json["title"],
    date: json["date"],
    isoDate: json["iso_date"] == null ? null : DateTime.parse(json["iso_date"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "date": date,
    "iso_date": "${isoDate!.year.toString().padLeft(4, '0')}-${isoDate!.month.toString().padLeft(2, '0')}-${isoDate!.day.toString().padLeft(2, '0')}",
  };
}
