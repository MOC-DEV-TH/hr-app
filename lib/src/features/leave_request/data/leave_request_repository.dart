import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/leave_request/model/leave_type_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../utils/secure_storage.dart';

part 'leave_request_repository.g.dart';

class LeaveRequestRepository {
  LeaveRequestRepository({required this.ref, required this.dio});

  final Ref ref;
  final Dio dio;

  ///get leave types
  Future<LeaveTypeResponse> fetchLeaveTypes() async {
    try {
      final response = await dio.get(kEndPointLeaveTypes);
      LeaveTypeResponse data = LeaveTypeResponse.fromJson(response.data);
      // await ref
      //     .read(secureStorageProvider)
      //     .saveLeaveTypes(data.data);
      debugPrint("Leave Type Response Data::${response.data}");

      return data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }

  ///send leave request
  Future<void> sendLeaveRequest({
    required date,
    required leaveType,
    required message,
  }) async {
    try {
      final response = await dio.post(
        kEndPointCreateLeave,
        data: {"date": date, "leave_type": leaveType, "message": message},
      );
      debugPrint("Send Leave Request response::${response.data}");
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "ERROR: Unknown Dio Error";
    }
  }
}

@riverpod
LeaveRequestRepository leaveRequestRepository(LeaveRequestRepositoryRef ref) {
  return LeaveRequestRepository(dio: ref.watch(dioProvider), ref: ref);
}

@riverpod
Future<LeaveTypeResponse> fetchLeaveTypesData(
  FetchLeaveTypesDataRef ref,
) async {
  final provider = ref.watch(leaveRequestRepositoryProvider);
  return provider.fetchLeaveTypes();
}
