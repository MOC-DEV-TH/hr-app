import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/leave_request/model/leave_type_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../network/api_constants.dart';
import '../../../network/dio_provider.dart';
import '../../../utils/secure_storage.dart';

part 'wfh_request_repository.g.dart';

class WfhRequestRepository {
  WfhRequestRepository({required this.ref, required this.dio});

  final Ref ref;
  final Dio dio;

  Future<void> sendWfhRequest(
      Map<String, dynamic> payload,
      ) async {
    try {
      final response = await dio.post(
        kEndPointCreateWfhRequest,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            debugPrint('VALIDATE STATUS = $status');

            return status != null && status < 400;
          },
        ),
      );

    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map && data['message'] != null) {
        throw data['message'].toString();
      }

      throw e.message ?? 'Network error';
    } catch (e, stackTrace) {
      rethrow;
    }
  }
}

@riverpod
WfhRequestRepository wfhRequestRepository(WfhRequestRepositoryRef ref) {
  return WfhRequestRepository(dio: ref.watch(dioProvider()), ref: ref);
}
