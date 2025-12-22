import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employee_wfh_requests/model/wfh_requests_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../network/error_handler.dart';
import '../../home/model/attendance_response.dart';
import '../../leave_status/model/leave_status_response.dart';

part 'employees_wfh_requests_repository.g.dart';

class EmployeesWfhRequestsRepository {
  EmployeesWfhRequestsRepository({required this.dio});

  final Dio dio;

  Future<WfhRequestsResponse> fetchAllEmployeesWfhRequests({
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

      final res = await dio.get(
        kEndPointWfhRequestList,
        queryParameters: query.isEmpty ? null : query,
      );
      return WfhRequestsResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? ErrorHandler.handle(e).failure.message;
    }
  }

  ///update employee leave request
  Future<LeaveStatusResponse> updateEmployeeWfhRequest({required int leaveId,required String status}) async {
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
EmployeesWfhRequestsRepository employeesWfhRequestsRepository(EmployeesWfhRequestsRepositoryRef ref) {
  return EmployeesWfhRequestsRepository(dio: ref.watch(dioProvider()));
}

@riverpod
Future<WfhRequestsResponse> fetchAllEmployeesWfhRequest(
    FetchAllEmployeesWfhRequestRef ref,{String? date,String? leaveStatus,}) async {
  final provider = ref.watch(employeesWfhRequestsRepositoryProvider);
  return provider.fetchAllEmployeesWfhRequests(date: date,leaveStatus: leaveStatus);
}
