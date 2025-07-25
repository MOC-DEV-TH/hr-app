import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';

part 'leave_status_repository.g.dart';

class LeaveStatusRepository {
  LeaveStatusRepository({required this.dio});

  final Dio dio;

  ///get all leave status
  Future<LeaveStatusResponse> fetchLeaveStatus() async {
    try {
      final response = await dio.get(kEndPointLeaveStatus);
      LeaveStatusResponse data = LeaveStatusResponse.fromJson(response.data);

      debugPrint("Leave Status Response Data::${response.data}");

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }
}

@riverpod
LeaveStatusRepository leaveStatusRepository(LeaveStatusRepositoryRef ref) {
  return LeaveStatusRepository(dio: ref.watch(dioProvider));
}

@riverpod
Future<LeaveStatusResponse> fetchLeaveStatusData(
  FetchLeaveStatusDataRef ref,
) async {
  final provider = ref.watch(leaveStatusRepositoryProvider);
  return provider.fetchLeaveStatus();
}
