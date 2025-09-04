import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_app/src/features/leave_request/model/leave_type_response.dart';
import 'package:hr_app/src/features/login/model/login_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

enum SecureDataList {
  token,
  fCMToken,
  isAlreadyLogin,
  isSignedIn,
  authToken,
  baseApiUrl,
  userData,
  leaveTypes,allowDistance,
  businessLat,
  businessLong
}

class SecureStorage {
  final GetStorage _box = GetStorage();

  ///auth flow
  saveAuthStatus(String status) async {
    await _box.write(SecureDataList.isSignedIn.name, status);
  }

  Future<String?> getAuthStatus() async {
    final res = await _box.read(SecureDataList.isSignedIn.name);
    return res;
  }

  /// User Data Methods (new)
  Future<void> saveUser(UserVO user) async {
    await _box.write(SecureDataList.userData.name, user.toJson());
  }

  ///get user Data
  Future<UserVO?> getUser() async {
    final data = _box.read(SecureDataList.userData.name);
    return data != null ? UserVO.fromJson(data) : null;
  }

  ///clear user
  Future<void> clearUser() async {
    await _box.remove(SecureDataList.userData.name);
  }

  /// Save Business Unit Config
  Future<void> saveBusinessUnitConfig({
    double? lat,
    double? long,
    int? allowDistance,
  }) async {
    if (lat != null) {
      await _box.write(SecureDataList.businessLat.name, lat);
    }
    if (long != null) {
      await _box.write(SecureDataList.businessLong.name, long);
    }
    if (allowDistance != null) {
      await _box.write(SecureDataList.allowDistance.name, allowDistance);
    }
  }

  /// Get Business Unit Latitude
  Future<double?> getBusinessLat() async {
    return _box.read(SecureDataList.businessLat.name);
  }

  /// Get Business Unit Longitude
  Future<double?> getBusinessLong() async {
    return _box.read(SecureDataList.businessLong.name);
  }

  /// Get Allow Distance
  Future<int?> getAllowDistance() async {
    return _box.read(SecureDataList.allowDistance.name);
  }


  Future<void> saveLeaveTypes(List<LeaveTypeVO> leaveTypes) async {
    final List<Map<String, dynamic>> leaveTypesJson =
        leaveTypes.map((type) => type.toJson()).toList();

    await _box.write(SecureDataList.leaveTypes.name, leaveTypesJson);
  }

  /// Get list of leave types
  Future<List<LeaveTypeVO>> getLeaveTypes() async {
    final data = _box.read(SecureDataList.leaveTypes.name);

    if (data == null) return [];
    try {
      return (data as List)
          .map((item) => LeaveTypeVO.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error parsing leave types: $e');
      return [];
    }
  }

  ///fcm token
  saveFCMToken(String fcmToken) async {
    await _box.write(SecureDataList.fCMToken.name, fcmToken);
  }

  ///get fcm token
  getFCMToken() {
    return _box.read(SecureDataList.fCMToken.name);
  }

  ///auth token
  saveAuthToken(String authToken) async {
    await _box.write(SecureDataList.authToken.name, authToken);
  }

  getAuthToken() {
    return _box.read(SecureDataList.authToken.name);
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorage();
}

@riverpod
Future<String?> getAuthStatus(GetAuthStatusRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getAuthStatus();
}

@riverpod
Future<UserVO?> getUserData(GetUserDataRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getUser();
}

@riverpod
Future<List<LeaveTypeVO>?> getLeaveTypes(GetLeaveTypesRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getLeaveTypes();
}
