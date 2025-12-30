import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/admin_dashboard/model/admin_dasbhoard_response.dart';
import 'package:hr_app/src/features/admin_dashboard/model/business_unit_response.dart';
import 'package:hr_app/src/features/employee_details/model/employee_profile_response.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';

part 'employee_leaves_repository.g.dart';

class EmployeeLeavesRepository {
  EmployeeLeavesRepository({required this.dio, required this.ref});

  final Dio dio;
  final Ref ref;

  Dio get _dioV2 => ref.read(dioProvider(baseUrl: kV2BaseUrl));

  ///fetch employee leaves
  Future<LeaveStatusResponse> fetchAllEmployeeLeaves({
    String? date,
    String? leaveStatus,
  }) async {
    try {
      final query = <String, String>{};

      if (date != null && date.trim().isNotEmpty) {
        query['date'] = date.trim();
      }
      if (leaveStatus != null &&
          leaveStatus.trim().isNotEmpty &&
          leaveStatus.trim().toLowerCase() != 'all') {
        query['status'] = leaveStatus.trim();
      }

      final res = await _dioV2.get(
        kEndPointGetAllEmployeeLeaves,
        queryParameters: query.isEmpty ? null : query,
      );
      return LeaveStatusResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }

  ///update employee leave request
  Future<LeaveStatusResponse> updateEmployeeLeaveRequest({
    required int leaveId,
    required String status,
  }) async {
    try {
      final response = await dio.post(
        kEndPointUpdateLeaveRequest,
        data: {"id": leaveId, "status": status},
      );
      LeaveStatusResponse data = LeaveStatusResponse.fromJson(response.data);
      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ??
          ErrorHandler.handle(e).failure.message;
    }
  }
}

@riverpod
EmployeeLeavesRepository employeeLeavesRepository(
  EmployeeLeavesRepositoryRef ref,
) {
  return EmployeeLeavesRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<LeaveStatusResponse> fetchAllEmployeeLeaves(
  FetchAllEmployeeLeavesRef ref, {
  String? date,
  String? leaveStatus,
}) async {
  final provider = ref.watch(employeeLeavesRepositoryProvider);
  return provider.fetchAllEmployeeLeaves(date: date, leaveStatus: leaveStatus);
}
