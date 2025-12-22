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

  Future<void> sendWfhRequest(dynamic payload) async {
    final res = await dio.post(
      kEndPointCreateWfhRequest,
      data: payload,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: res.data["message"],
      );
    }
  }
}

@riverpod
WfhRequestRepository wfhRequestRepository(WfhRequestRepositoryRef ref) {
  return WfhRequestRepository(dio: ref.watch(dioProvider()), ref: ref);
}
