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
    required String date,
    required int leaveType,
    required String message,
    required int halfDay,
    String? period,
  }) async {
    Response<dynamic> response;

    try {
      final Map<String, dynamic> payload = {
        "date": date,
        "leave_type": leaveType,
        "message": message,
      };

      if (halfDay == 1 && period != null) {
        payload["period"] = period;
        payload["half_day"] = halfDay;
      }

      response = await dio.post(
        kEndPointCreateLeave,
        data: payload,
        options: Options(validateStatus: (s) => s != null && s < 400),
      );
    } on DioException catch (e) {
      final msg = _extractServerMessage(e.response?.data) ??
          e.message ??
          'Network error';
      throw msg;
    } catch (e) {
      throw 'Unexpected error: $e';
    }

    final sc = response.statusCode ?? 0;
    if (sc >= 400) {
      final msg = _extractServerMessage(response.data) ??
          'HTTP $sc: ${response.statusMessage ?? 'Server error'}';
      throw msg;
    }
  }

  String? _extractServerMessage(dynamic data) {
    try {
      if (data == null) return null;
      if (data is String) return data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      if (data is Map && data['error'] is String) {
        return data['error'] as String;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

}

@riverpod
LeaveRequestRepository leaveRequestRepository(LeaveRequestRepositoryRef ref) {
  return LeaveRequestRepository(dio: ref.watch(dioProvider()), ref: ref);
}

@riverpod
Future<LeaveTypeResponse> fetchLeaveTypesData(
  FetchLeaveTypesDataRef ref,
) async {
  final provider = ref.watch(leaveRequestRepositoryProvider);
  return provider.fetchLeaveTypes();
}
