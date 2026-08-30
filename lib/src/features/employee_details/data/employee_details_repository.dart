import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/admin_dashboard/model/admin_dasbhoard_response.dart';
import 'package:hr_app/src/features/admin_dashboard/model/business_unit_response.dart';
import 'package:hr_app/src/features/employee_details/model/employee_profile_response.dart';
import 'package:hr_app/src/features/employee_details/model/leave_summary_response.dart';
import 'package:hr_app/src/features/employee_details/model/profile_wfh_requests_response.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../employee_wfh_requests/model/wfh_requests_response.dart';

part 'employee_details_repository.g.dart';

class EmployeeDetailsRepository {
  EmployeeDetailsRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));

  ///fetch employee profile
  Future<EmployeeProfileResponse> fetchEmployeeProfileData({
    required int userId,
  }) async {
    try {
      final response = await _dioV2.post(
        kEndPointGetEmployeeDetails,
        data: {"user_id": userId, "type": 'profile'},
      );
      EmployeeProfileResponse data = EmployeeProfileResponse.fromJson(
        response.data,
      );
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch employee wfh request by status
  Future<ProfileWfhRequestsResponse> fetchEmployeeWfhRequest({
    required int userId,
    required String status,
    required int pageNo
  }) async {
    try {
      final response = await _dioV2.post(
        kEndPointGetEmployeeWfhRequestByStatus,
        data: {"user_id": userId, "type": 'wfh','status' : status,"per_page": 10,
          "page": pageNo},
      );
      ProfileWfhRequestsResponse data = ProfileWfhRequestsResponse.fromJson(
        response.data,
      );
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch employee leaves
  Future<LeaveStatusResponse> fetchEmployeeLeaves({required int userId,required String leaveStatus}) async {
    try {
      final response = await _dioV2.post(
        kEndPointGetEmployeeDetails,
        data: {"user_id": userId, "type": 'leaves','status' : leaveStatus},
      );
      LeaveStatusResponse data = LeaveStatusResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch employee attendances
  Future<AttendanceResponse> fetchEmployeeAttendances({
    required int userId,
    required String year,
    required String month,
  }) async {
    try {
      final response = await dio.post(
        kEndPointGetEmployeeDetails,
        data: {
          "user_id": userId,
          "type": 'attendance',
          "year": year,
          "month": month,
        },
      );
      AttendanceResponse data = AttendanceResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///fetch leave summary
  Future<LeaveSummaryResponse> fetchEmployeeLeaveSummary({required int userId}) async {
    try {
      final response = await dio.post(
        kEndPointGetEmployeeDetails,
        data: {"user_id": userId, "type": 'leave-summary'},
      );
      LeaveSummaryResponse data = LeaveSummaryResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
EmployeeDetailsRepository employeeDetailsRepository(
  EmployeeDetailsRepositoryRef ref,
) {
  return EmployeeDetailsRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<EmployeeProfileResponse> fetchEmployeeProfileData(
  FetchEmployeeProfileDataRef ref, {
  required int userID,
}) async {
  final provider = ref.watch(employeeDetailsRepositoryProvider);
  return provider.fetchEmployeeProfileData(userId: userID);
}

@riverpod
Future<LeaveStatusResponse> fetchEmployeeLeavesData(
  FetchEmployeeLeavesDataRef ref, {
  required int userID,
      required String leaveStatus
}) async {
  final provider = ref.watch(employeeDetailsRepositoryProvider);
  return provider.fetchEmployeeLeaves(userId: userID,leaveStatus: leaveStatus);
}

@riverpod
Future<AttendanceResponse> fetchEmployeeAttendancesData(
    FetchEmployeeAttendancesDataRef ref, {
      required int userID,
      required String year,
      required String month
    }) async {
  final provider = ref.watch(employeeDetailsRepositoryProvider);
  return provider.fetchEmployeeAttendances(userId: userID,year:year,month:month);
}

@riverpod
Future<LeaveSummaryResponse> fetchEmployeeLeaveSummaryData(
    FetchEmployeeLeaveSummaryDataRef ref, {
      required int userID,
    }) async {
  final provider = ref.watch(employeeDetailsRepositoryProvider);
  return provider.fetchEmployeeLeaveSummary(userId: userID);
}

@riverpod
Future<ProfileWfhRequestsResponse> fetchEmployeeWfhRequestData(
    FetchEmployeeWfhRequestDataRef ref, {
      required int userID,
      required String status,
      required int pageNo
    }) async {
  final provider = ref.watch(employeeDetailsRepositoryProvider);
  return provider.fetchEmployeeWfhRequest(userId: userID,status: status,pageNo: pageNo);
}
