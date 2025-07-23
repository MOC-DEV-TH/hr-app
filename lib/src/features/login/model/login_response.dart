import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int? statusCode;
  String? message;
  UserData? data;

  LoginResponse({this.statusCode, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    statusCode: json["status_code"] as int?,
    message: json["message"] as String?,
    data:
        json["data"] != null
            ? UserData.fromJson(json["data"] as Map<String, dynamic>)
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (statusCode != null) "status_code": statusCode,
    if (message != null) "message": message,
    if (data != null) "data": data!.toJson(),
  };
}

class UserData {
  String? accessToken;
  String? tokenType;
  UserVO? user;

  UserData({this.accessToken, this.tokenType, this.user});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    accessToken: json["access_token"] as String?,
    tokenType: json["token_type"] as String?,
    user:
        json["user"] != null
            ? UserVO.fromJson(json["user"] as Map<String, dynamic>)
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (accessToken != null) "access_token": accessToken,
    if (tokenType != null) "token_type": tokenType,
    if (user != null) "user": user!.toJson(),
  };
}

class UserVO {
  int? id;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  String? phone;
  int? positionId;
  int? departmentId;
  int? bussinessUnitId;
  int? countryId;
  int? isDepartmentHead;
  DateTime? twoFactorConfirmedAt;
  int? currentTeamId;
  String? profilePhotoPath;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserVO({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.positionId,
    this.departmentId,
    this.bussinessUnitId,
    this.countryId,
    this.isDepartmentHead,
    this.twoFactorConfirmedAt,
    this.currentTeamId,
    this.profilePhotoPath,
    this.createdAt,
    this.updatedAt,
  });

  factory UserVO.fromJson(Map<String, dynamic> json) => UserVO(
    id: json["id"] as int?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    emailVerifiedAt:
        json["email_verified_at"] != null
            ? DateTime.tryParse(json["email_verified_at"] as String)
            : null,
    phone: json["phone"] as String?,
    positionId: json["position_id"] as int?,
    departmentId: json["department_id"] as int?,
    bussinessUnitId: json["bussiness_unit_id"] as int?,
    countryId: json["country_id"] as int?,
    isDepartmentHead: json["is_department_head"] as int?,
    twoFactorConfirmedAt:
        json["two_factor_confirmed_at"] != null
            ? DateTime.tryParse(json["two_factor_confirmed_at"] as String)
            : null,
    currentTeamId: json["current_team_id"] as int?,
    profilePhotoPath: json["profile_photo_path"] as String?,
    createdAt:
        json["created_at"] != null
            ? DateTime.tryParse(json["created_at"] as String)
            : null,
    updatedAt:
        json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"] as String)
            : null,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (name != null) "name": name,
    if (email != null) "email": email,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    if (phone != null) "phone": phone,
    if (positionId != null) "position_id": positionId,
    if (departmentId != null) "department_id": departmentId,
    if (bussinessUnitId != null) "bussiness_unit_id": bussinessUnitId,
    if (countryId != null) "country_id": countryId,
    if (isDepartmentHead != null) "is_department_head": isDepartmentHead,
    "two_factor_confirmed_at": twoFactorConfirmedAt?.toIso8601String(),
    if (currentTeamId != null) "current_team_id": currentTeamId,
    if (profilePhotoPath != null) "profile_photo_path": profilePhotoPath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
