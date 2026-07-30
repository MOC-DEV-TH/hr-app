import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_app/src/features/leave_request/model/leave_type_response.dart';
import 'package:hr_app/src/features/login/model/login_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/admin_dashboard/model/business_unit_response.dart';
import '../features/admin_dashboard/model/employee_dropdown_response.dart';
import '../features/home/model/user_address_response.dart';

part 'secure_storage.g.dart';

enum SecureDataList {
  fCMToken,
  isAlreadyLogin,
  isSignedIn,
  authToken,
  baseApiUrl,
  userData,
  leaveTypes,allowDistance,
  businessLat,
  businessLong,
  loginUserRole,
  isRemoteLogin,
  employeeDropdown,
  businessUnits,
  employeeAddressList,
  checkInDate,
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


  saveLoginUserRole(String status) async {
    await _box.write(SecureDataList.loginUserRole.name, status);
  }

  Future<String?> getLoginUserRole() async {
    final res = await _box.read(SecureDataList.loginUserRole.name);
    return res;
  }


  ///remote login status
  saveIsRemoteLogin(String status) async {
    await _box.write(SecureDataList.isRemoteLogin.name, status);
  }

  Future<String?> getRemoteLoginStatus() async {
    final res = await _box.read(SecureDataList.isRemoteLogin.name);
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

  Future<void> saveEmployeeDropdown(EmployeeDropdownVO data) async {
    await _box.write(SecureDataList.employeeDropdown.name, data.toJson());
  }

  /// Read entire dropdowns
  Future<EmployeeDropdownVO?> getEmployeeDropdown() async {
    final raw = _box.read(SecureDataList.employeeDropdown.name);
    if (raw == null) return null;
    try {
      return EmployeeDropdownVO.fromJson(Map<String, dynamic>.from(raw));
    } catch (e) {
      debugPrint('Error parsing employee dropdown: $e');
      return null;
    }
  }

  Future<void> saveBusinessUnits(List<BusinessUnitVO> units) async {
    final jsonList = units.map((u) => u.toJson()).toList();
    await _box.write(SecureDataList.businessUnits.name, jsonList);
  }

  /// Get ALL business units list
  Future<List<BusinessUnitVO>> getBusinessUnitsAll() async {
    final data = _box.read(SecureDataList.businessUnits.name);
    if (data == null) return [];

    try {
      return (data as List)
          .map((e) => BusinessUnitVO.fromJson(
        Map<String, dynamic>.from(e as Map),
      ))
          .toList();
    } catch (e) {
      debugPrint('Error parsing business units: $e');
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

  /// Save check-in date
  Future<void> saveCheckInDate(String checkInDate) async {
    await _box.write(
      SecureDataList.checkInDate.name,
      checkInDate,
    );
  }

  /// Get check-in date synchronously
  String? getCheckInDate() {
    final value = _box.read(SecureDataList.checkInDate.name);
    return value?.toString();
  }

  /// Clear check-in date
  Future<void> clearCheckInDate() async {
    await _box.remove(SecureDataList.checkInDate.name);
  }

  /// Convenience getters
  Future<List<IDNameVO>> getCountries() async {
    final d = await getEmployeeDropdown();
    return d?.countries ?? const <IDNameVO>[];
  }

  Future<List<IDNameVO>> getBusinessUnits() async {
    final d = await getEmployeeDropdown();
    return d?.businessUnits ?? const <IDNameVO>[];
  }

  Future<List<IDNameVO>> getDepartments() async {
    final d = await getEmployeeDropdown();
    return d?.departments ?? const <IDNameVO>[];
  }

  Future<List<IDNameVO>> getPositions() async {
    final d = await getEmployeeDropdown();
    return d?.positions ?? const <IDNameVO>[];
  }

  Future<List<IDNameVO>> getRoles() async {
    final d = await getEmployeeDropdown();
    return d?.roles ?? const <IDNameVO>[];
  }

  Future<List<IDNameVO>> getEmployeeTypes() async {
    final d = await getEmployeeDropdown();
    return d?.employeeTypes ?? const <IDNameVO>[];
  }

  void saveEmployeeAddresses(List<AddressVO> list) {
    final jsonList = list.map((e) => e.toJson()).toList();
    _box.write(SecureDataList.employeeAddressList.name, jsonList);
  }

  List<AddressVO> getEmployeeAddressesSync() {
    final raw = _box.read(SecureDataList.employeeAddressList.name);
    if (raw == null) return [];

    try {
      return (raw as List)
          .map((e) => AddressVO.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  void clearEmployeeAddresses() {
    _box.remove(SecureDataList.employeeAddressList.name);
  }

  UserVO? getUserSync() {
    final raw = _box.read(
      SecureDataList.userData.name,
    );

    if (raw == null || raw is! Map) {
      return null;
    }

    try {
      return UserVO.fromJson(
        Map<String, dynamic>.from(raw),
      );
    } catch (error) {
      debugPrint(
        'Error parsing saved user: $error',
      );

      return null;
    }
  }

  int? getUserId() {
    return getUserSync()?.id;
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
Future<String?> getLoginUserRole(GetLoginUserRoleRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getLoginUserRole();
}

@riverpod
Future<String?> getRemoteLoginStatus(GetRemoteLoginStatusRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getRemoteLoginStatus();
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

@riverpod
Future<EmployeeDropdownVO?> employeeDropdownLocal(EmployeeDropdownLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getEmployeeDropdown();
}

@riverpod
Future<List<IDNameVO>> countriesLocal(CountriesLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getCountries();
}

@riverpod
Future<List<IDNameVO>> businessUnitsLocal(BusinessUnitsLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getBusinessUnits();
}

@riverpod
Future<List<IDNameVO>> departmentsLocal(DepartmentsLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getDepartments();
}

@riverpod
Future<List<IDNameVO>> positionsLocal(PositionsLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getPositions();
}

@riverpod
Future<List<IDNameVO>> rolesLocal(RolesLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getRoles();
}

@riverpod
Future<List<IDNameVO>> employeeTypesLocal(EmployeeTypesLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getEmployeeTypes();
}

@riverpod
Future<List<BusinessUnitVO>> businessUnitsAllLocal(
    BusinessUnitsAllLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getBusinessUnitsAll();
}

@riverpod
List<AddressVO> employeeAddressesLocal(EmployeeAddressesLocalRef ref) {
  final store = ref.watch(secureStorageProvider);
  return store.getEmployeeAddressesSync();
}

@riverpod
String? getCheckInDate(GetCheckInDateRef ref) {
  final storage = ref.watch(secureStorageProvider);
  return storage.getCheckInDate();
}

@riverpod
int? getUserId(GetUserIdRef ref) {
  final storage = ref.watch(
    secureStorageProvider,
  );

  return storage.getUserId();
}



